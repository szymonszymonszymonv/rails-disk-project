<template>
    <v-dialog
      v-model="dialog"
      max-width="600px"
    >
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          color="primary"
          dark
          v-bind="attrs"
          v-on="on"
        >
          Log in
        </v-btn>
      </template>
      <v-form @submit="submit">
        <v-card>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="email"
                  label="Email*"
                  placeholder="wizard@example.com"
                  type="email"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-text-field
                  v-model="password"
                  label="Password*"
                  type="password"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
          <small>*indicates required field</small>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="dialog = false"
          >
            Close
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            type="submit"
            @click="dialog = false"
          >
            Submit
          </v-btn>
        </v-card-actions>
        </v-card>
      </v-form>
    </v-dialog>
</template>

<script>
import axios from 'axios'
  export default {

    data: () => ({
        dialog: false,
        email: '',
        password: ''
    }),


    methods: {
        submit(){
            const token = document.querySelector('meta[name="csrf-token"]').content
            axios
            .post('/login', {
                email: this.email,
                password: this.password,
                headers: {
                  'X-Requested-With': 'XMLHttpRequest',
                  'X-CSRF-Token': token,
                  "Content-Type": "application/json",
                  'Accept': 'application/json'
                },
                credentials: 'same-origin'
            })
            .then(response => {
                console.log(response)
                if(response.data.status != "not_found"){
                    this.$emit("user-logged-in", response.data.directories)
                    localStorage.user = response.data.user
                    localStorage.directories = JSON.stringify(response.data.directories)
                }
            })
        }
    }
  }
</script>