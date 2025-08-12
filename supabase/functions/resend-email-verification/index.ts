import { serve } from "https://deno.land/std@0.192.0/http/server.ts";

serve(async (req) => {
  // ✅ CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*", // DO NOT CHANGE THIS
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "*" // DO NOT CHANGE THIS
      }
    });
  }
  
  try {
    const { email, token, user_name = "New User" } = await req.json();
    
    if (!email || !token) {
      throw new Error("Email and verification token are required");
    }

    // Send verification email via Resend API
    const resendResponse = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${Deno.env.get("RESEND_API_KEY")}`,
      },
      body: JSON.stringify({
        from: "onboarding@resend.dev",
        to: [email],
        subject: "Verify your NomadNest account",
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center;">
              <h1 style="color: white; margin: 0; font-size: 28px;">Welcome to NomadNest!</h1>
            </div>
            
            <div style="padding: 40px 30px; background: white;">
              <p style="font-size: 16px; color: #333; margin-bottom: 20px;">Hi ${user_name},</p>
              
              <p style="font-size: 16px; color: #333; line-height: 1.6; margin-bottom: 30px;">
                Thank you for joining NomadNest! To complete your account setup and start connecting with nomads worldwide, please verify your email address.
              </p>
              
              <div style="text-align: center; margin: 40px 0;">
                <div style="background: #f8f9fa; border: 2px dashed #667eea; border-radius: 8px; padding: 20px; display: inline-block; font-size: 32px; font-weight: bold; color: #667eea; letter-spacing: 3px;">
                  ${token}
                </div>
              </div>
              
              <p style="font-size: 14px; color: #666; text-align: center; margin-bottom: 30px;">
                Enter this 6-digit code in the app to verify your account. Code expires in 10 minutes.
              </p>
              
              <div style="background: #f8f9fa; border-radius: 8px; padding: 20px; margin: 30px 0;">
                <h3 style="color: #333; margin-top: 0;">What's next?</h3>
                <ul style="color: #666; line-height: 1.6; padding-left: 20px;">
                  <li>Complete your profile setup</li>
                  <li>Connect with nomads in your city</li>
                  <li>Discover amazing travel opportunities</li>
                  <li>Join local meetups and events</li>
                </ul>
              </div>
              
              <p style="font-size: 14px; color: #999; margin-top: 40px;">
                If you did not create this account, you can safely ignore this email.
              </p>
            </div>
            
            <div style="background: #f8f9fa; padding: 20px 30px; text-align: center; color: #666; font-size: 12px;">
              <p>NomadNest - Connecting Digital Nomads Worldwide</p>
            </div>
          </div>
        `,
      }),
    });

    const result = await resendResponse.json();
    
    if (!resendResponse.ok) {
      throw new Error(`Resend API error: ${result.message}`);
    }

    return new Response(JSON.stringify({
      success: true,
      message: "Verification email sent successfully",
      email_id: result.id
    }), {
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*" // DO NOT CHANGE THIS
      }
    });
    
  } catch (error) {
    return new Response(JSON.stringify({
      error: error.message
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json", 
        "Access-Control-Allow-Origin": "*" // DO NOT CHANGE THIS
      }
    });
  }
});