# PlayVerse Frontend

Next.js frontend for PlayVerse portfolio + game UI.

## Setup

1. Install dependencies:
	- `npm install`
2. Copy env template:
	- `cp .env.example .env.local`
3. Set API URL in `.env.local`:
	- `NEXT_PUBLIC_API_URL=http://localhost:5000`

## Development

- Start dev server: `npm run dev`
- Build for production: `npm run build`
- Run production server: `npm run start`

## Deploy (Vercel)

1. Import `playverse/frontend` in Vercel.
2. Add environment variable:
	- `NEXT_PUBLIC_API_URL=https://your-backend-domain.vercel.app`
3. Deploy.

## Notes

- UI is built with a bamboo-inspired visual theme and enhanced game showcase cards.
- Backend status link on the homepage uses `NEXT_PUBLIC_API_URL`.
