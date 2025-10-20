<template>
  <div v-if="isOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 profile-modal" @click="closeProfile">
    <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 transform transition-all duration-300 profile-card" @click.stop>
      <!-- Header -->
      <div class="bg-gradient-to-r from-blue-500 to-purple-600 p-6 rounded-t-lg text-white">
        <div class="flex justify-between items-center">
          <h2 class="text-xl font-bold">Profilo Utente</h2>
          <button 
            @click="closeProfile"
            class="text-white hover:text-gray-200 transition-colors duration-200"
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
            <div class="w-24 h-24 bg-gradient-to-br from-blue-400 to-purple-500 rounded-full flex items-center justify-center text-white text-3xl font-bold shadow-lg profile-avatar">
              {{ user.username[0].toUpperCase() }}
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
            <div class="bg-gray-50 rounded-lg p-3 border">
              <p class="text-lg font-semibold text-gray-800">{{ user.username }}</p>
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
            @click="editProfile"
            class="flex-1 bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-200 flex items-center justify-center space-x-2 profile-button"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
            </svg>
            <span>Modifica</span>
          </button>
          <button 
            @click="closeProfile"
            class="flex-1 bg-gray-500 hover:bg-gray-600 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-200 profile-button"
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
  emits: ['close'],
  methods: {
    closeProfile() {
      this.$emit('close');
    },
    editProfile() {
      // TODO: Implementare modifica profilo
      console.log('Modifica profilo');
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
/* Animazioni personalizzate */
.transform {
  transition: transform 0.3s ease-in-out;
}

/* Hover effects */
button:hover {
  transform: translateY(-1px);
}

/* Responsive design */
@media (max-width: 640px) {
  .max-w-md {
    max-width: 95%;
  }
}
</style>
