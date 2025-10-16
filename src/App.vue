<template>
  <div class="h-full">
    <Login v-if="!isAuthenticated" @login="handleLogin" />
    <Chat v-else :user="currentUser" :token="token" @logout="handleLogout" />
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import Login from './components/Login.vue'
import Chat from './components/Chat.vue'

export default {
  name: 'App',
  components: {
    Login,
    Chat
  },
  setup() {
    const isAuthenticated = ref(false)
    const currentUser = ref(null)
    const token = ref(null)

    onMounted(() => {
      const savedToken = localStorage.getItem('token')
      const savedUser = localStorage.getItem('user')
      
      if (savedToken && savedUser) {
        // Verifica che l'ID dell'utente corrisponda al token JWT
        try {
          const tokenPayload = JSON.parse(atob(savedToken.split('.')[1]))
          const savedUserData = JSON.parse(savedUser)
          
          
          if (tokenPayload.user_id.toString() !== savedUserData.id.toString()) {
            localStorage.removeItem('token')
            localStorage.removeItem('user')
            return
          }
        } catch (error) {
          localStorage.removeItem('token')
          localStorage.removeItem('user')
          return
        }
        
        token.value = savedToken
        currentUser.value = JSON.parse(savedUser)
        isAuthenticated.value = true
      }
    })

    const handleLogin = (loginData) => {
      token.value = loginData.token
      currentUser.value = loginData.user
      isAuthenticated.value = true
      
      localStorage.setItem('token', loginData.token)
      localStorage.setItem('user', JSON.stringify(loginData.user))
    }

    const handleLogout = () => {
      isAuthenticated.value = false
      currentUser.value = null
      token.value = null
      
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    }

    return {
      isAuthenticated,
      currentUser,
      token,
      handleLogin,
      handleLogout
    }
  }
}
</script>
