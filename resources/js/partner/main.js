/**
 * Libraries
 */
import Vue from 'vue';
import axios from 'axios';
import VueAxios from 'vue-axios';
import VueI18n from 'vue-i18n';
import store from './store';
import UIkit from 'uikit';
import Icons from 'uikit/dist/js/uikit-icons';
import Vue2Filters from 'vue2-filters';

/**
 * Import Vue components
 */
import UsersIndexPage from './pages/UsersIndex.vue';

/**
 * Plugins
 */
Vue.use(VueAxios, axios);
Vue.use(VueI18n);
Vue.use(Vue2Filters);
UIkit.use(Icons);

/**
 * Setup app
 */
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

const i18n = new VueI18n({
  locale: document.documentElement.lang,
  silentFallbackWarn: true,
  messages: {
    en: {
      global: {
        loading: 'Loading...',
        no_items: 'No items',
      }
    },
    ru: {
      global: {
        loading: 'Загрузка...',
        no_items: 'Пусто',
      }
    }
  }
});

/**
 * Register Vue components
 */
Vue.component('users-index-page', UsersIndexPage);

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */
const admin_app = new Vue({
    i18n,
    el: '#partner_app',
    store
});
