// Asset preloader for examples
(function () {
    'use strict';

    const DEFAULT_PRELOAD_CONCURRENCY = 8;

    function detectGameName() {
        const parts = window.location.pathname.split('/').filter(Boolean);
        if (parts.length === 0) return '';
        const last = parts[parts.length - 1];
        if (last.endsWith('.html')) {
            return parts.length >= 2 ? parts[parts.length - 2] : '';
        }
        return last;
    }

    const gameName = detectGameName();
    if (!gameName) return;

    const ASSETS_BASE_PATH = `assets/${gameName}/`;
    const MANIFEST_PATH = ASSETS_BASE_PATH + 'assets-manifest.json';

    function preferredConcurrency() {
        const hardware = navigator.hardwareConcurrency || DEFAULT_PRELOAD_CONCURRENCY;
        return Math.max(4, Math.min(DEFAULT_PRELOAD_CONCURRENCY, hardware));
    }

    function waitForIdle() {
        return new Promise(resolve => {
            if (typeof window.requestIdleCallback === 'function') {
                window.requestIdleCallback(() => resolve(), { timeout: 200 });
            } else {
                window.setTimeout(resolve, 0);
            }
        });
    }

    async function preloadWithConcurrency(assetPaths, limit) {
        let index = 0;

        async function worker() {
            while (index < assetPaths.length) {
                const currentIndex = index;
                index += 1;
                const path = assetPaths[currentIndex];
                try {
                    await fetch(ASSETS_BASE_PATH + path);
                } catch (error) {
                    console.warn('Failed to preload asset:', path, error);
                }
            }
        }

        const workers = Array.from(
            { length: Math.min(limit, assetPaths.length) },
            () => worker(),
        );
        await Promise.all(workers);
    }

    // Fetch and preload all assets
    async function preloadAssets() {
        try {
            // Fetch the manifest
            const response = await fetch(MANIFEST_PATH);
            if (!response.ok) {
                console.warn('Failed to load asset manifest:', response.statusText);
                return;
            }

            const assetPaths = await response.json();
            console.log(`Found ${assetPaths.length} assets to preload`);

            // Yield one frame before starting network-heavy background work.
            await waitForIdle();
            await preloadWithConcurrency(assetPaths, preferredConcurrency());
            console.log('All assets preloaded successfully');

        } catch (error) {
            console.error('Error preloading assets:', error);
        }
    }

    // Start preloading when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', preloadAssets);
    } else {
        preloadAssets();
    }
})();
