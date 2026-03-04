// Asset preloader for cards game
(function () {
    'use strict';

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

    const ASSETS_BASE_PATH = `/assets/${gameName}/`;
    const MANIFEST_PATH = ASSETS_BASE_PATH + 'assets-manifest.json';

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

            // Preload all assets in the background
            const preloadPromises = assetPaths.map(path =>
                fetch(ASSETS_BASE_PATH + path)
            );

            // Wait for all assets to preload
            await Promise.all(preloadPromises);
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
