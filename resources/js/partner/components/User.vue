<template>
  <tr>
    <td>{{ curUser.email }}</td>
    <td v-if="isEdit"><input class="uk-input uk-form-small" type="text" v-model="modelName" :disabled="ajax" v-bind:class="{'uk-form-danger': formErrors.name}"></td>
    <td v-else>{{ curUser.name }}</td>

    <td v-if="isEdit">
      <select class="uk-select uk-form-small" v-model="modelRole" :disabled="ajax">
        <option >
          none
        </option>
      </select>
    </td>
    <td v-else>{{ roleName }}</td>
    <td v-if="isEdit" class="uk-text-center"><input class="uk-checkbox" type="checkbox" v-model="modelActive" :disabled="ajax"></td>
    <td v-else class="uk-text-center"><span v-if="curUser.active" uk-icon="check"></span></td>
    <template v-if="$store.getters.isAdmin">
      <td v-if="isEdit" class="uk-text-right">
        <div uk-spinner v-if="ajax"></div>
        <span v-else>
          <a href="#" class="uk-icon-link" uk-icon="close" @click.prevent="cancel"></a>
          <a href="#" class="uk-icon-link" uk-icon="check" @click.prevent="save"></a>
        </span>
      </td>
      <td v-else class="uk-text-right">
        <a href="#" class="uk-icon-link" uk-icon="pencil" @click.prevent="edit"></a>
      </td>
    </template v-else>
  </tr>
</template>

<script>
  import AjaxErrors from '../mixins/AjaxErrors';

  export default {
    data() {
      return {
        isEdit: false,
        ajax: false,
        roles: [],
        curUser: {},

        modelActive: false,
        modelName: '',
        modelRole: '',

        formErrors: {
          name: false,
          address: false,
        },

        originActive: false,
        originRole: '',
        originName: '',
      }
    },
    mixins: [AjaxErrors],
    props: ['user'],
    mounted() {
      this.curUser = this.user;

      this.modelActive = this.user.active === 1;
      this.modelName = this.user.name;
      this.modelRole = this.user.role;
    },
    computed: {
      roleName: function() {
        if (this.roles.length === 0) {
          return 'none';
        } else {
          let index = this.roles.map(x => {
            return x.code;
          }).indexOf(this.modelPrefecture);

          return this.roles[index].prefecture_name;
        }
      }
    },
    methods: {
      edit: function() {
        if (this.ajax) return;
        this.isEdit = true;
      },
      cancel: function() {
        this.isEdit = false;
      },
      save: function() {
        this.ajax = true;
        this.formErrors.name = false;
        this.formErrors.address = false;

        this.axios.put(`/api/partner/users/${this.seller.id}`, {
          active: this.modelActive,
          name: this.modelName,
          prefecture_code: this.modelPrefecture == 0 ? '' : this.modelPrefecture,
          address: this.modelAddress
        })
        .then((response) => {
          this.curUser.active = this.modelActive;
          this.curUser.name = this.modelName;
          this.curUser.prefecture_code = this.modelPrefecture;
          this.curUser.address = this.modelAddress;
          this.isEdit = false;
          this.ajax = false;
        })
        .catch((error) => {
          this.showErrors(error);
        });
      },
    }
  }
</script>
