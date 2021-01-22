import UIkit from 'uikit';

export default {
  methods: {
    showErrors: function(error) {
      this.ajax = false;
      if (error.response.data.errors) {
        for (var prop in error.response.data.errors) {
          this.formErrors[prop] = true;
        }
      } else {
        console.log(error);
        UIkit.notification({
          message: 'API error',
          status: 'warning',
          pos: 'bottom-right',
          timeout: 8000
        });
      }
    }
  }
}
