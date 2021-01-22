<template>
  <div uk-sticky="sel-target: .uk-container; cls-active: uk-navbar-sticky">
    <div class="uk-container uk-container-expand uk-margin-bottom uk-background-default uk-box-shadow-small">
      <nav uk-navbar>
        <div class="uk-navbar-center">
          <ul class="uk-subnav uk-subnav-pill uk-margin-remove-bottom" uk-switcher>
            <li><a href="#" @click="filterBy('admin')">{{ $t('admin') }}</a></li>
            <li><a href="#" @click="filterBy('moderator')">{{ $t('moderator') }}</a></li>
            <li><a href="#" @click="filterBy('guest')">{{ $t('guest') }}</a></li>
          </ul>
        </div>
      </nav>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {}
    },
    i18n: {
      messages: {
        en: {
          admin: 'admin',
          moderator: 'moderator',
          guest: 'guest',
        },
        ru: {
          admin: 'admin',
          moderator: 'moderator',
          guest: 'guest',
        }
      }
    },
    methods: {
      filterBy: function(filter) {
        this.$emit('filter-by', filter);
      }
    }
  }
</script>
