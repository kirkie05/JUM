-- ============================================================
-- JUM Backend Schema v3
-- Migration 007: Edge Function Reference
--
-- This file is documentation only — it lists all Edge
-- Functions needed, their paths, and what they do.
-- The actual function code lives in supabase/functions/.
-- Deploy with: supabase functions deploy <function-name>
-- ============================================================

/*
EDGE FUNCTION: create-payment-intent
  Method:  POST
  Auth:    authenticated
  Purpose: Creates a Stripe PaymentIntent for giving or marketplace
  Input:   { amount: number, currency: string, category?: string, product_id?: string }
  Output:  { client_secret: string, payment_intent_id: string }
  Notes:   Never allow clients to write giving_transactions directly.
           This function creates the pending record, payment webhook confirms it.

EDGE FUNCTION: paystack-webhook
  Method:  POST
  Auth:    service_role (verified via x-paystack-signature HMAC)
  Purpose: Handle Paystack payment.success → mark transaction paid + trigger receipt
  Input:   Paystack webhook raw payload
  Output:  { received: true }
  Notes:   Verify HMAC of raw body against PAYSTACK_SECRET_KEY before processing.
           Update donations.status = 'paid'.
           Trigger generate-receipt.

EDGE FUNCTION: stripe-webhook
  Method:  POST
  Auth:    service_role (verified via Stripe-Signature header)
  Purpose: Handle payment_intent.succeeded for giving + marketplace orders
  Input:   Stripe raw webhook payload
  Output:  { received: true }
  Notes:   Check metadata.type = 'giving' or 'order' to route correctly.
           Update donations or orders accordingly.

EDGE FUNCTION: submit-form
  Method:  POST
  Auth:    authenticated (or anon for anonymous prayer)
  Purpose: Validate form data, insert form, auto-assign to least-busy leader,
           send OneSignal push notification to assigned leader
  Input:   { type: string, data_json: object, submitted_by?: string }
  Output:  { form_id: string, assigned_to: string }
  Notes:   Query users WHERE role = 'leader', pick one with fewest open forms.
           INSERT into forms table.
           POST to OneSignal notifications API.
           INSERT into notifications table for in-app alert.

EDGE FUNCTION: create-rsvp
  Method:  POST
  Auth:    authenticated
  Purpose: Generate unique QR code, create RSVP row, return QR string
  Input:   { event_id: string }
  Output:  { rsvp_id: string, qr_code: string }
  Notes:   QR payload format: "JUM-{event_id}-{user_id}-{uuid4}"
  Check UNIQUE constraint — return existing RSVP if already registered.

EDGE FUNCTION: generate-receipt
  Method:  POST
  Auth:    service_role
  Purpose: Generate PDF giving receipt, upload to Supabase Storage, update receipt_url, email
  Input:   { transaction_id: string }
  Output:  { receipt_url: string }
  Notes:   Fetch transaction + user data from Supabase.
           Generate PDF using @deno-libs/pdf or jsPDF (Deno-compatible).
           Upload to receipts/{user_id}/{transaction_id}.pdf.
           Update donations.receipt_url.
           Send Resend email with receipt attached.
*/
