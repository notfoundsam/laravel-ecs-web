const mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel applications. By default, we are compiling the CSS
 | file for the application as well as bundling up all the JS files.
 |
 */

/* Admin js & css */
mix.js('resources/js/admin/auth.js', 'public/js/admin')
    .js('resources/js/admin/main.js', 'public/js/admin')
    .sass('resources/sass/admin/auth.scss', 'public/css/admin')
    .sass('resources/sass/admin/vendor.scss', 'public/css/admin')
    .sass('resources/sass/admin/main.scss', 'public/css/admin')
    .version();

/* Partner js & css */
mix.js('resources/js/partner/auth.js', 'public/js/partner')
    .js('resources/js/partner/main.js', 'public/js/partner')
    .sass('resources/sass/partner/auth.scss', 'public/css/partner')
    .sass('resources/sass/partner/vendor.scss', 'public/css/partner')
    .sass('resources/sass/partner/main.scss', 'public/css/partner')
    .version();

/* Web js & css */
mix.js('resources/js/web/home.js', 'public/js/web')
    .sass('resources/sass/web/main.scss', 'public/css/web')
    .sass('resources/sass/web/home.scss', 'public/css/web')
    .version();

mix.browserSync({
    port: 9011,
    proxy: 'nginx:80',
    open: false,
    notify: false,
});
