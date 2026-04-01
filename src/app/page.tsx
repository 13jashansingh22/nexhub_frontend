export default function Home() {
  const apiBase = process.env.NEXT_PUBLIC_API_URL || "http://localhost:5000";

  const featuredGames = [
    {
      title: "Neon Drift Arena",
      genre: "Arcade Racing",
      status: "Live",
      accent: "from-[#61d49e] to-[#2d6d53]",
    },
    {
      title: "Temple Stack Rush",
      genre: "Puzzle Action",
      status: "Beta",
      accent: "from-[#f4cc74] to-[#9b6a24]",
    },
    {
      title: "Shadow Kunai",
      genre: "Stealth Platformer",
      status: "Live",
      accent: "from-[#b4f06f] to-[#4b7a2f]",
    },
  ];

  return (
    <div className="relative flex-1 overflow-hidden">
      <div className="grain" aria-hidden />
      <main className="relative z-10 mx-auto w-full max-w-6xl px-5 py-8 md:px-10 md:py-14">
        <section className="fade-up card-shell rounded-3xl p-6 md:p-10">
          <div className="mb-8 flex flex-wrap items-center justify-between gap-4">
            <div>
              <p className="chip mb-3 inline-flex rounded-full px-3 py-1 text-xs tracking-[0.22em] uppercase">
                Portfolio + Game Studio
              </p>
              <h1 className="text-3xl font-semibold leading-tight md:text-5xl">
                Bamboo Lab Style, <span className="text-[#b4f06f]">PlayVerse Core</span>
              </h1>
              <p className="mt-3 max-w-2xl text-sm text-[var(--text-muted)] md:text-base">
                Crafted with a natural-tech visual language: textured layers, moss gradients,
                tactical cards, and game-first interactions for your portfolio brand.
              </p>
            </div>
            <div className="chip rounded-2xl px-4 py-3 text-xs font-medium">
              API Base: {apiBase}
            </div>
        </div>

          <div className="fade-up-delay-1 grid gap-4 md:grid-cols-3">
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">
              <p className="text-xs uppercase tracking-[0.18em] text-[var(--text-muted)]">Identity</p>
              <h3 className="mt-2 text-lg font-semibold">Bamboo Rhythm UI</h3>
              <p className="mt-2 text-sm text-[var(--text-muted)]">Organic geometry + sharp game HUD contrast.</p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">
              <p className="text-xs uppercase tracking-[0.18em] text-[var(--text-muted)]">Backend</p>
              <h3 className="mt-2 text-lg font-semibold">MongoDB Connected</h3>
              <p className="mt-2 text-sm text-[var(--text-muted)]">Auth, leaderboard, and progress endpoints prepared.</p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">
              <p className="text-xs uppercase tracking-[0.18em] text-[var(--text-muted)]">Deploy</p>
              <h3 className="mt-2 text-lg font-semibold">Vercel Ready</h3>
              <p className="mt-2 text-sm text-[var(--text-muted)]">Environment-driven config for production launch.</p>
            </div>
          </div>

          <div className="fade-up-delay-2 mt-8 flex flex-wrap gap-3">
            <a className="cta-primary rounded-full px-5 py-3 text-sm font-semibold" href="#games">
              Explore Game UI
            </a>
            <a
              className="cta-secondary rounded-full px-5 py-3 text-sm font-semibold"
              href={`${apiBase}/health`}
              target="_blank"
              rel="noreferrer"
            >
              Check Backend Health
            </a>
          </div>
        </section>

        <section id="games" className="mt-8 fade-up-delay-2">
          <div className="mb-4 flex items-center justify-between">
            <h2 className="text-2xl font-semibold md:text-3xl">Featured Games</h2>
            <span className="chip rounded-full px-3 py-1 text-xs">Enhanced UI Cards</span>
          </div>
          <div className="grid gap-4 md:grid-cols-3">
            {featuredGames.map((game) => (
              <article key={game.title} className="game-tile rounded-2xl p-4">
                <div className={`h-2 w-full rounded-full bg-gradient-to-r ${game.accent}`} />
                <p className="mt-3 text-xs uppercase tracking-[0.15em] text-[var(--text-muted)]">{game.genre}</p>
                <h3 className="mt-2 text-xl font-semibold">{game.title}</h3>
                <div className="mt-5 flex items-center justify-between">
                  <span className="chip rounded-full px-3 py-1 text-xs">{game.status}</span>
                  <button className="rounded-full border border-[#61d49e]/40 px-3 py-1 text-xs font-semibold text-[#b4f06f]">
                    Launch
                  </button>
                </div>
              </article>
            ))}
          </div>
        </section>

        <section className="mt-8 card-shell rounded-3xl p-6 md:p-8">
          <h2 className="text-2xl font-semibold">Frontend + Backend Separation</h2>
          <p className="mt-2 text-sm text-[var(--text-muted)] md:text-base">
            Frontend runs in a dedicated Next.js app and backend runs as a separate Express API with MongoDB.
            Connect them using <code className="font-mono text-[#f4cc74]">NEXT_PUBLIC_API_URL</code> and deploy each
            service independently.
          </p>
        </section>
      </main>
    </div>
  );
}
