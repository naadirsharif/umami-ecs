export async function GET() {
  console.log("🔥 DATABASE_URL:", process.env.DATABASE_URL);

  return Response.json({ ok: true });
}