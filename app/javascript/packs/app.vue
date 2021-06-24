<template>
  <v-app>
    
    <!-- <v-app-bar v-if="!isLoggedIn">
      <v-spacer></v-spacer>
      <LoginForm/>
      <RegisterForm/>
    </v-app-bar>
    
    <v-app-bar v-else>
      <v-spacer></v-spacer>
      <a> hi, {{ user }}  </a>
      <LogoutItem/>
    </v-app-bar> -->

    <ExtendedToolbar 
    :isLoggedIn='this.isLoggedIn'
    :directoriesPreview='this.directories'

    />


  </v-app>
</template>

<script>
import SystemBar from './components/system-bar.vue'
import LoginForm from './components/login-form.vue'
import RegisterForm from './components/register-form.vue'
import LogoutItem from './components/logout-item.vue'
import ExtendedToolbar from './components/extended-toolbar.vue'

export default {


  data: () => {
    return {
      user: '',
      files: [],
      directories: [],
      path: []
    }
  },

  computed: {
    isLoggedIn(){
      return localStorage.getItem("user")
    }
  },

  mounted(){
    this.user = localStorage.user
    this.initPreview()
  },

  components: {
    SystemBar,
    LoginForm,
    RegisterForm,
    LogoutItem,
    ExtendedToolbar
  },

  methods: {
    
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>

