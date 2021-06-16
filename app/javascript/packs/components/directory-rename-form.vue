<template>
    <v-dialog
      v-model="dialog"
      max-width="600px"
    >
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          v-bind="attrs"
          v-on="on"
        >
          Rename
        </v-btn>
      </template>
      <v-form @submit.prevent="Rename">
        <v-card>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="name"
                  label="New directory name*"
                  placeholder="Videos"
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
        id: Number
    },

    data: () => {
        return {
            dialog: false,
            name: ''
        }
    },

    computed: {

    },

    methods: {
        Rename(){
            let path = '/directories/' + this.id + '/update_name'
            axios
            .put(path, {
                name: this.name,
                id: this.id
            })
            .then(response => {
                console.log(response)
                if(response.data.status != "not_found"){
                    console.log('SUCCESS')
                    this.$emit('rename-directory', this.name)
                }
            })
        }
    }
}
</script>