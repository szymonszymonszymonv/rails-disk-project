<template>
    <v-btn @click="logout"
    color="red darken-4"
    type="submit"
    dark
    text
    pa-6
    >Logout</v-btn>
</template>

<script>
import axios from 'axios'
export default {

    data: () => {
        return {

        }
    },

    methods:{
        logout(){
            const token = document.querySelector('meta[name="csrf-token"]').content
            axios
            .delete("/logout", {
                headers: {
                  'X-Requested-With': 'XMLHttpRequest',
                  'X-CSRF-Token': token,
                  "Content-Type": "application/json",
                  'Accept': 'application/json'
                },
                credentials: 'same-origin'
            })
            .then(response => {
                location.reload()
                console.log(response)
                localStorage.clear()
            })
            console.log(localStorage)
        }
    }
}
</script>