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
          Create directory
        </v-btn>
      </template>
      <v-form @submit.prevent="createDirectory">
        <v-card>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="name"
                  label="Directory name*"
                  placeholder="Photos"
                  type="name"
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

    props: {
      path: Array,
      user: String,
      directories: Array
    },

    data: () => {
        return {
            dialog: false,
            name: ''
        }
    },

    computed: {
        parentId(){
            let idd = this.path[this.path.length - 1].id
            if(idd == -1){
              return null
            }
            else{
              return idd
            }
        }
    },

    methods: {
        createDirectory(){
          console.log(this.parentId)
            const token = document.querySelector('meta[name="csrf-token"]').content
            axios
            .post('/directories', {
                user: this.user,
                name: this.name,
                parent_id: this.parentId,
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
                    console.log('SUCCESS')
                    console.log('in form: ' + this.directories)

                    let tmpdir = this.directories
                    tmpdir.push(response.data.directory)
                    // this.directories(response.data.directory)
                    localStorage.directories = JSON.stringify(tmpdir)
                    console.log("TYPE OF LOCALSTORAGE.DIRECTORIES >> " + typeof(localStorage.directories))
                    this.$emit('create-directory', tmpdir)
                }
            })
        }
    }
}
</script>