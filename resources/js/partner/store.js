import Vuex from 'vuex';
import Vue from 'vue';

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    locale: document.documentElement.lang,
    role: document.getElementById('partner_app') ? parseInt(document.getElementById('partner_app').getAttribute('data-role')) : 0,
    dashboardInfo: {}
  },
  mutations: {
    setLocale(state, locale) {
      state.locale = locale;
    }
  },
  actions: {},
  getters: {
    isAdmin: state => {
      return state.role === 1;
    },
    getLocale: state => {
      return state.locale;
    }
  },
});

export default store;
