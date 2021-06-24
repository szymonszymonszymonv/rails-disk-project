<template>
    <v-app id="inspire">
        <v-app-bar
        app
        >

        <v-toolbar-title>potezny dysk</v-toolbar-title>

        
        <template v-if='!isLoggedIn'>
            <v-spacer></v-spacer>
            <LoginForm v-on:user-logged-in="updateData($event)"
            />    
            <RegisterForm/>    
        </template>
        <template v-else>
            
            <v-spacer></v-spacer>
            <h4> hi, {{user}} </h4>
            <LogoutItem/>
        </template>

            <v-menu
                bottom
                right
            >
                <template v-slot:activator="{ on, attrs }">
                <v-btn
                    icon
                    v-bind="attrs"
                    v-on="on"
                >
                    <v-icon>mdi-dots-vertical</v-icon>
                </v-btn>
                
                </template>
                <v-list>
                    <v-list-item>
                        <DirectoryForm
                        :directories='this.directories'
                        :path='this.path' 
                        :user='this.user'
                        v-on:create-directory='updateDirectories($event)'
                        />
                    </v-list-item>
                    <v-list-item>
                        <v-bottom-sheet
                        v-model='sheet'>
                            <template v-slot:activator="{ on, attrs }">
                                <v-btn
                                v-on="on"
                                v-bind="attrs"
                                >
                                    Upload file
                                </v-btn>
                            </template>
                            <v-sheet
                            class="text-center"
                            height="200px"
                            >
                                <v-btn
                                class="mt-6"
                                text
                                color="red"
                                @click="sheet = !sheet"
                                >
                                    Close
                                </v-btn>
                                <template>
                                    <v-file-input
                                        v-model="upload_files"
                                        :rules="rules"
                                        show-size
                                        counter
                                        multiple
                                        label="File input"
                                    ></v-file-input>
                                </template>
                                <v-btn
                                class="mt-6"
                                text
                                color="blue"
                                @click="uploadFiles"
                                >
                                    Upload
                                </v-btn>
                            </v-sheet>
                        </v-bottom-sheet>
                    </v-list-item>
                </v-list>

            </v-menu>
        </v-app-bar>
        
        <v-main :style="styleObject">
            <v-system-bar
            height="40"
            color="dark-green"
            dark
            >

                <v-item-group
                v-for='item in this.path'
                :key='item.id'
                >
                    <v-item>
                        <v-btn
                        depressed
                        elevation="1"
                        rounded
                        text
                        v-on:click="changeDirectoryBack(item.id, item.name)"
                        >
                            {{item.name}}
                        </v-btn>
                    </v-item>
                </v-item-group>

            </v-system-bar>
        <v-container>
            <v-row>
            <v-col
                v-for="dir in directories"
                :key="dir.id"
                cols="2"
            >
                <DirectoryItem
                :name='dir.name'
                :id='dir.id'
                v-on:destroy-directory='deleteFromDirectories($event)'
                v-on:rename-directory='updateName($event, dir.id)'
                @dblclick.native="changeCurrentDirectory(dir.id, dir.name)"
                />
                
            </v-col>
            <v-col
                v-for="fil in current_files"
                :key="fil[1]"
                cols="2"
            >
                <FileItem
                :name='fil[0]'
                :id='fil[1]'
                v-on:destroy-file="updateFiles($event)"
                />
            </v-col>
            </v-row>
        </v-container>
        </v-main>
    </v-app>
</template>

<script>
import LoginForm from './login-form.vue'
import RegisterForm from './register-form.vue'
import LogoutItem from './logout-item.vue'
import DirectoryForm from './directory-form.vue'
import DirectoryItem from './directory-item.vue'
import FileItem from './file-item.vue'
import axios from 'axios'

export default {
    props: ['isLoggedIn', 'directoriesPreview'],

    data: () => {
        return {
            path: [
                {
                    name: 'ROOT',
                    id: -1
                },
            ],
            user: '',
            directories: [],
            menu_components: ['DirectoryForm', 'Upload File'],
            actions: [ 
                {
                    type: 'Delete'
                },
                {
                    type: 'Rename'
                },
                {
                    type: 'Share'
                }
            ],
                
            show: false,
            sheet: false,
            active_element: -1,
            x: 0,
            y: 0,
            rules: [
                v => !!v || 'File is required',
                v => (v && v.length > 0) || 'File is required',
                files => !files || !files.some(file => file.size > 5e6) || 'Total size should be less than 5 MB!'
            ],
            upload_files: [],
            current_files: []
        }
    },

    computed: {
        styleObject(){
            if(!this.isLoggedIn){
                return {
                    filter: 'blur(3px)',
                    'pointer-events': 'none'
                }
            }
        },

        directory_img(){
            return require('../directory.png')
        },
        currentDirectory(){
            return this.path[this.path.length - 1]
        }
    },

    mounted(){
        this.user = localStorage.user
        if(localStorage.getItem("directories")){
            let tmpdirs = localStorage.directories
            this.directories = JSON.parse(tmpdirs)
        }
        if(localStorage.getItem("path")){
            let tmppath = localStorage.path
            this.path = JSON.parse(tmppath)
        }
        if(localStorage.getItem("current_files")){
            let tmpfils = localStorage.current_files
            this.current_files = JSON.parse(tmpfils)
        }

    },

    components: {
        LoginForm,
        RegisterForm,
        LogoutItem,
        DirectoryForm,
        DirectoryItem,
        FileItem
    },

    methods: {

        updateDirectories(updatedDirectory){
            console.log('in toolbar: ' + this.directories)
            this.directories = updatedDirectory
            localStorage.directories = this.directories
            // this.$emit('update-directories', this.directories)
        },

        updateData(directories){
            this.user = localStorage.user
            this.directories = directories
            // this.$emit('update-data', this.directories)
        },


        showMenu(e, id){
            this.show = false
            this.active_element = -1
            this.x = e.clientX
            this.y = e.clientY
            this.$nextTick(() => {
                this.active_element = id
                this.show = true
            })
        },
        deleteFromDirectories(id){
            console.log("z folderow usuwam: " + id)
            let idx = this.directories.findIndex(x => x.id == id)
            this.directories.splice(idx, 1)
            localStorage.directories = JSON.stringify(this.directories)
            // directories where dir.id == id - remove
        },
        updateName(newName, id){
            console.log("zmieniam nazwe folderu: " + id)
            let idx = this.directories.findIndex(x => x.id == id)
            this.directories[idx].name = newName
            localStorage.directories = JSON.stringify(this.directories)
        },
        changeCurrentDirectory(dir_id, dir_name){

            this.path.push( {name: dir_name, id: dir_id} )
            localStorage.path = JSON.stringify(this.path)
            let url = '/directories/' + dir_id + '/children'
            axios
            .get(url, {
                id: dir_id
            })
            .then(response => {
                console.log(response)
                if(response.data.status != "not_found"){
                    console.log('SUCCESS')
                    this.directories = response.data.directories
                    localStorage.directories = JSON.stringify(this.directories)
                }
            })
            this.getFiles()

        },
        changeDirectoryBack(dir_id){
            let idx = this.path.map(e => {return e.id}).indexOf(dir_id) + 1
            if(idx + 1 > this.path.length){
                return -1
            }
            let url = ''
            let countRemoved = this.path.length - (idx)
            console.log('idx: ', idx)
            console.log('dlugosc sciezki: ' + this.path.length)
            console.log("USUWAMY: " + countRemoved)
            let removedElements = this.path.splice(idx, countRemoved)
            console.log(removedElements)
            localStorage.path = JSON.stringify(this.path)

            if(dir_id == -1){
                url = '/start'
                this.current_files = []
                axios
                .post(url, {email: this.user})
                .then(response => {
                    console.log(response)
                    if(response.data.status != "not_found"){
                        console.log('SUCCESS')
                        this.directories = response.data.directories
                        localStorage.directories = JSON.stringify(this.directories)
                    }
                })
            }

            else{
                console.log("NIE ZMIENIAMY NA ROOTA")
                url = '/directories/' + dir_id + '/children'

                axios
                .get(url, {id: dir_id})
                .then(response => {
                    console.log(response)
                    if(response.data.status != "not_found"){
                        console.log('SUCCESS')
                        this.directories = response.data.directories
                        localStorage.directories = JSON.stringify(this.directories)
                    }
                })
                this.getFiles()
            }


        },
        getFiles(){
            if(this.currentDirectory.id == -1){
                alert("you can't be in the root directory when uploading files. try entering a directory first.")
                return -1
            }
            axios
            .get('/directories/' + this.currentDirectory.id + '/upload')
            .then(response => {
                console.log(response)
                if(response.data.status != "not_found"){
                    console.log('SUCCESS')
                    console.log(response.data.files)
                    this.current_files = response.data.files
                    localStorage.current_files = this.current_files
                    console.log(this.current_files)
                }
            })
        },
        uploadFiles(){
            if(this.currentDirectory.id == -1){
                alert("you can't be in the root directory when uploading files. try entering a directory first.")
                return -1
            }
            for(let i = 0; i < this.upload_files.length; i++){
                let file = this.upload_files[i]
                let formData = new FormData
                formData.append('upload[parent_id]', this.currentDirectory.id)
                formData.append('upload[files]', file)
                console.log(file)
                axios
                .put('/directories/' + this.currentDirectory.id + '/upload', formData) 
                // {
                //     parent_id: this.currentDirectory.id,
                //     files: this.upload_files
                // })
                .then(response => {
                    console.log(response)
                    if(response.data.status != "not_found"){
                        console.log('SUCCESS')
                        this.getFiles()
                    }
                })
            }
            
        },
        updateFiles(id){
            let idx = this.current_files.map(i => { return i[1] }).indexOf(id)
            this.current_files.splice(idx, 1)
            localStorage.current_files = this.current_files
        }


    }
}
</script>