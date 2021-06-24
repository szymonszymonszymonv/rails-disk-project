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
                max-height="80px"
                :src='file_img'
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
                    <!-- <FileRenameForm
                    :id='this.id'
                    v-on:rename-file='updateName($event)'/> -->
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
                    type: 'Share'
                }
            ],

            show: false,
            x: 0,
            y: 0
        }
    },
    
    components:{
        // FileRenameForm
    },

    computed: {
        file_img(){
            return require('../file.png')
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
            let path = '/directories/files/' + this.id
            axios
            .delete(path, {
                id: this.id
            })
            .then(response => {
                console.log(response)
                if(response.data.status != "not_found"){
                    console.log('SUCCESS')
                    this.$emit('destroy-file', this.id)
                }
            })
        },

        Share(){
            axios
            .get('directories/files/' + this.id)
            .then(response => {
                console.log(response.data.link)
                let link = response.data.link
                navigator.clipboard.writeText(link)
                .then(() => {
                    alert("Coppied to clipboard successfully!")
                }, (err) => {
                    console.log("error: " + err)
                })
            })
        },
        
        updateName(newName){
            this.$emit('rename-file', newName)
        }

    }
}
</script>