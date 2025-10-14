<template>
  <div class="min-h-screen flex items-center justify-center p-4">
    <div class="card w-full max-w-md animate-fade-in">
      <div class="card-header">
        <h2 class="text-2xl font-semibold text-center text-gray-800">
          {{ isRegister ? 'Crea Account' : 'Benvenuto' }}
        </h2>
        <p class="text-sm text-gray-600 text-center mt-1">
          {{ isRegister ? 'Registrati per iniziare a chattare' : 'Accedi al tuo account' }}
        </p>
      </div>
      
      <div class="card-body">
        <form @submit.prevent="handleSubmit" class="space-y-4">
          <div v-if="isRegister" class="space-y-2">
            <label class="block text-sm font-medium text-gray-700">Username</label>
            <input 
              v-model="username" 
              type="text" 
              required
              placeholder="Scegli un username"
              class="input-field"
            />
          </div>
          
          <div class="space-y-2">
            <label class="block text-sm font-medium text-gray-700">
              {{ isRegister ? 'Email' : 'Username o Email' }}
            </label>
            <input 
              v-model="email" 
              :type="isRegister ? 'email' : 'text'" 
              required
              :placeholder="isRegister ? 'la-tua-email@esempio.com' : 'Username o email'"
              class="input-field"
            />
          </div>
          
          <div class="space-y-2">
            <label class="block text-sm font-medium text-gray-700">Password</label>
            <input 
              v-model="password" 
              type="password" 
              required
              placeholder="La tua password"
              class="input-field"
            />
          </div>
          
          <div v-if="error" class="p-3 bg-red-50 border border-red-200 rounded-lg">
            <p class="text-red-600 text-sm">{{ error }}</p>
          </div>
          
          <button 
            type="submit"
            :disabled="loading"
            class="btn-primary w-full"
          >
            <span v-if="loading" class="flex items-center justify-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Caricamento...
            </span>
            <span v-else>{{ isRegister ? 'Crea Account' : 'Accedi' }}</span>
          </button>
        </form>
        
        <div class="mt-6 text-center">
          <p class="text-sm text-gray-600">
            {{ isRegister ? 'Hai già un account?' : 'Non hai un account?' }}
            <button 
              @click="isRegister = !isRegister" 
              class="text-blue-600 hover:text-blue-700 font-medium ml-1 transition-colors duration-200"
            >
              {{ isRegister ? 'Accedi' : 'Registrati' }}
            </button>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'

export default {
  name: 'Login',
  emits: ['login'],
  setup(props, { emit }) {
    const isRegister = ref(false)
    const username = ref('')
    const email = ref('')
    const password = ref('')
    const error = ref('')
    const loading = ref(false)

    const handleSubmit = async () => {
      error.value = ''
      loading.value = true

      try {
        const action = isRegister.value ? 'register' : 'login'
        const body = isRegister.value 
          ? { username: username.value, email: email.value, password: password.value }
          : { username: email.value, password: password.value }

        const response = await fetch(`/api/auth.php`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ action, ...body })
        })

        const data = await response.json()

        if (!response.ok) {
          error.value = data.error || 'Errore durante l\'operazione'
          return
        }

        emit('login', data)
      } catch (err) {
        error.value = 'Errore di connessione'
      } finally {
        loading.value = false
      }
    }

    return {
      isRegister,
      username,
      email,
      password,
      error,
      loading,
      handleSubmit
    }
  }
}
</script>
