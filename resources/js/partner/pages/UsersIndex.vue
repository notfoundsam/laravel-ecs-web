<template>
  <div>
    <user-filter
      @filter-by="getUsers"
    ></user-filter>
    <div class="uk-container uk-container-expand">
      <div class="area-users-index">

        <div class="uk-card uk-card-default uk-card-small uk-width-1 uk-card-body uk-margin" v-if="showUsersTable">
          <table class="uk-table uk-table-small uk-table-middle uk-table-divider">
            <thead>
              <tr>
                <th class="uk-width-auto">{{ $t('email') }}</th>
                <th class="uk-width-medium">{{ $t('name') }}</th>
                <th class="uk-width-small">{{ $t('role') }}</th>
                <th class="uk-table-shrink">{{ $t('active') }}</th>
                <th class="edit-column" v-if="$store.getters.isAdmin"></th>
              </tr>
            </thead>
            <transition-group name="list" tag="tbody">
              <user
                v-for="user in users"
                :key="user.id"
                :user="user"
              ></user>
            </transition-group>
          </table>
        </div>

        <div class="uk-card uk-card-default uk-card-small uk-width-1 uk-card-body uk-text-center" v-else>{{ $t('global.loading') }}</div>

      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.edit-column {
  width: 50px;
}
.uk-width-postcode {
  width: 100px;
}
</style>

<script>
  import User from '../components/User.vue';
  import UserFilter from '../components/UserFilter.vue';

  export default {
    data() {
      return {
        showUsersTable: false,
        users: [],
      }
    },
    components: {
      User,
      UserFilter
    },
    i18n: {
      messages: {
        en: {
          email: 'email',
          name: 'name',
          role: 'role',
          active: 'active',
        },
        ru: {
          email: 'email',
          name: 'name',
          role: 'role',
          active: 'active',
        }
      }
    },
    mounted() {
      this.getUsers('admin');
    },
    methods: {
      getUsers: function(filter) {
        this.showUsersTable = false;

        this.axios.get('/partner/ajax/vue_users', {
          params: {
            filter: filter
          }
        })
        .then((response) => {
          this.showUsersTable = true;
          this.users = response.data.users;
        })
        .catch((error) => {
          console.log(error);
        });
      },
    }
  }
</script>
