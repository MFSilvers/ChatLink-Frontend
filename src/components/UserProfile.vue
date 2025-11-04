<template>
  <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" @click="closeProfile">
    <div class="bg-white rounded-lg shadow-lg max-w-md w-full mx-4" @click.stop>
      <!-- Header -->
      <div class="bg-blue-600 p-6 rounded-t-lg text-white">
        <div class="flex justify-between items-center">
          <h2 class="text-xl font-bold">Profilo Utente</h2>
          <button 
            @click="closeProfile"
            class="text-white hover:text-blue-200 transition-colors duration-150"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>
        </div>
      </div>

      <!-- Profile Content -->
      <div class="p-6">
        <!-- Profile Picture -->
        <div class="flex justify-center mb-6">
          <div class="relative">
            <div class="w-24 h-24 bg-blue-600 rounded-full flex items-center justify-center text-white text-3xl font-bold">
              {{ (editingUsername || user.username)[0].toUpperCase() }}
            </div>
            <div class="absolute -bottom-1 -right-1 w-6 h-6 bg-green-500 rounded-full border-2 border-white flex items-center justify-center">
              <div class="w-2 h-2 bg-white rounded-full"></div>
            </div>
          </div>
        </div>

        <!-- User Info -->
        <div class="space-y-4">
          <!-- Username -->
          <div class="text-center">
            <label class="block text-sm font-medium text-gray-700 mb-1">Nome Utente</label>
            <div v-if="!isEditing" class="bg-gray-50 rounded-lg p-3 border">
              <p class="text-lg font-semibold text-gray-800">{{ user.username }}</p>
            </div>
            <div v-else class="space-y-2">
              <input 
                v-model="editingUsername"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Inserisci nuovo username"
                maxlength="20"
                @keyup.enter="saveUsername"
                @keyup.escape="cancelEdit"
              />
              <div v-if="usernameError" class="text-red-500 text-sm">{{ usernameError }}</div>
            </div>
          </div>

          <!-- Email -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <div class="bg-gray-50 rounded-lg p-3 border">
              <p class="text-gray-800">{{ user.email || 'Email non disponibile' }}</p>
            </div>
          </div>

          <!-- Status -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Stato</label>
            <div class="bg-gray-50 rounded-lg p-3 border">
              <div class="flex items-center space-x-2">
                <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                <span class="text-green-600 font-medium">Online</span>
              </div>
            </div>
          </div>

          <!-- Member Since -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Membro dal</label>
            <div class="bg-gray-50 rounded-lg p-3 border">
              <p class="text-gray-800">{{ formatDate(user.created_at) }}</p>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="mt-6 flex space-x-3">
          <button 
            v-if="!isEditing"
            @click="startEdit"
            class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-150 flex items-center justify-center space-x-2"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
            </svg>
            <span>Modifica Username</span>
          </button>
          
          <template v-else>
            <button 
              @click="saveUsername"
              :disabled="isSaving || !editingUsername.trim()"
              class="flex-1 bg-green-600 hover:bg-green-700 disabled:bg-gray-400 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-150 flex items-center justify-center space-x-2"
            >
              <svg v-if="isSaving" class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
              </svg>
              <span>{{ isSaving ? 'Salvando...' : 'Salva' }}</span>
            </button>
            <button 
              @click="cancelEdit"
              :disabled="isSaving"
              class="flex-1 bg-gray-500 hover:bg-gray-600 disabled:bg-gray-400 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-150"
            >
              Annulla
            </button>
          </template>
          
          <button 
            v-if="!isEditing"
            @click="closeProfile"
            class="flex-1 bg-gray-500 hover:bg-gray-600 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-150"
          >
            Chiudi
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UserProfile',
  props: {
    isOpen: {
      type: Boolean,
      default: false
    },
    user: {
      type: Object,
      required: true
    }
  },
  emits: ['close', 'updateUser'],
  data() {
    return {
      isEditing: false,
      editingUsername: '',
      isSaving: false,
      usernameError: ''
    }
  },
  methods: {
    closeProfile() {
      this.cancelEdit();
      this.$emit('close');
    },
    startEdit() {
      this.isEditing = true;
      this.editingUsername = this.user.username;
      this.usernameError = '';
    },
    cancelEdit() {
      this.isEditing = false;
      this.editingUsername = '';
      this.usernameError = '';
      this.isSaving = false;
    },
    async saveUsername() {
      if (!this.editingUsername.trim()) {
        this.usernameError = 'Username non può essere vuoto';
        return;
      }
      
      if (this.editingUsername === this.user.username) {
        this.cancelEdit();
        return;
      }
      
      if (this.editingUsername.length < 3) {
        this.usernameError = 'Username deve essere di almeno 3 caratteri';
        return;
      }
      
      this.isSaving = true;
      this.usernameError = '';
      
      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '') || '';
        const response = await fetch(`${apiUrl}/api/users.php`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          },
          body: JSON.stringify({
            username: this.editingUsername.trim()
          })
        });
        
        if (response.ok) {
          const data = await response.json().catch(() => ({}));
          const updatedUser = { ...this.user, username: data.username || this.editingUsername.trim() };
          this.$emit('updateUser', updatedUser);
          this.cancelEdit();
        } else {
          try {
            const error = await response.json();
            this.usernameError = error.error || error.message || `Errore ${response.status}: ${response.statusText}`;
          } catch (e) {
            this.usernameError = `Errore ${response.status}: ${response.statusText}`;
          }
        }
      } catch (error) {
        console.error('Errore:', error);
        this.usernameError = 'Errore di connessione';
      } finally {
        this.isSaving = false;
      }
    },
    formatDate(dateString) {
      if (!dateString) return 'Data non disponibile';
      const date = new Date(dateString);
      return date.toLocaleDateString('it-IT', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    }
  }
}
</script>

<style scoped>
/* Ottimizzazioni per performance - rimossi effetti pesanti */
button:disabled {
  cursor: not-allowed;
}

/* Animazione semplice per il loading spinner */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}

/* Responsive design */
@media (max-width: 640px) {
  .max-w-md {
    max-width: 95%;
  }
}
</style>