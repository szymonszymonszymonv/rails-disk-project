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
            Register
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
                <v-col cols="12">
                    <v-text-field
                    v-model="password_confirmation"
                    label="Confirm password*"
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
                @click="dialog = false"
                type="submit"
            >
                Save
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
      password: '',
      password_confirmation: ''
    }),

    methods: {
        submit(){
            axios
            .post('/register', {
                email: this.email,
                password: this.password,
                password_confirmation: this.password_confirmation
            })
            .then(response => {
                console.log(response)
                if(response.data.status != "not_found"){
                    localStorage.user = response.data.user
                    localStorage.directories = response.data.directories
                }
            })
        }
    }
  }
</script>