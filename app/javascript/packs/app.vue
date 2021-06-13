<template>
  <v-app>
    <v-app-bar>
      <LoginForm/>
      <RegisterForm/>
    </v-app-bar>
    <!-- <SystemBar/> -->

  </v-app>
</template>

<script>
import SystemBar from './components/system-bar.vue'
import LoginForm from './components/login-form.vue'
import RegisterForm from './components/register-form.vue'

export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  },
  components: {
    SystemBar,
    LoginForm,
    RegisterForm
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
