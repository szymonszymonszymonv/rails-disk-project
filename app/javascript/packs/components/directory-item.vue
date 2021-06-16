<template>
    <div>
        <v-card 
        v-on:click="{}"
        @click.right.prevent="showMenu($event, id)"
        height="150" 
        >

            <v-img
                contain
                class="white--text align-end"
                max-height="100px"
                :src='directory_img'
            >
            </v-img>
            <v-card-subtitle> {{name}} </v-card-subtitle>
        </v-card>

        <v-menu
        v-model="show"
        :position-x="x"
        :position-y="y"
        absolute
        offset-y
        >
            <v-list>
                <v-list-item> 
                    <DirectoryRenameForm
                    :id='this.id'
                    v-on:rename-directory='updateName($event)'/>
                </v-list-item>
                <v-list-item v-for='(item, i) in actions'
                :key='i'>
                    <v-btn
                    @click="handleFunctionCall(item.type)">
                        {{item.type}}
                    </v-btn>
                </v-list-item>
            </v-list>
        </v-menu>
    </div>
    
</template>

<script>
import axios from 'axios'
import DirectoryRenameForm from './directory-rename-form.vue'

export default {
    props: {
        id: Number,
        name: String
    },

    data: () => {
        return {
            actions: [ // pass name of clicked dir as props
                {
                    type: 'Delete'
                },
                {
                    type: 'Cut'
                }
            ],

            show: false,
            x: 0,
            y: 0
        }
    },
    
    components:{
        DirectoryRenameForm
    },

    computed: {
        directory_img(){
            return require('../directory.png')
        }
    },

    methods: {
        showMenu(e){
            this.show = false
            this.x = e.clientX
            this.y = e.clientY
            this.$nextTick(() => {
                this.show = true
            })
        },

        handleFunctionCall(fname){
            this[fname]()
        },

        Delete(){
            console.log("usuwam folder" + this.id)
            let path = '/directories/' + this.id
            axios
            .delete(path, {
                id: this.id
            })
            .then(response => {
                console.log(response)
                if(response.data.status != "not_found"){
                    console.log('SUCCESS')
                    this.$emit('destroy-directory', this.id)
                }
            })
        },
        
        updateName(newName){
            this.$emit('rename-directory', newName)
        }

    }
}
</script>