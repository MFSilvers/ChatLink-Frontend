<template>
  <div class="flex h-screen">
    <!-- Sidebar - Responsive -->
    <div class="w-full md:w-1/3 lg:w-1/4 sidebar flex flex-col" :class="{ 'hidden': !showSidebar, 'block': showSidebar }">
      <div class="card-header flex justify-between items-center">
        <div class="flex items-center space-x-3 cursor-pointer hover:bg-gray-50 p-2 rounded-lg transition-colors duration-200" @click="openUserProfile">
          <div class="avatar avatar-blue">
            {{ user.username[0].toUpperCase() }}
          </div>
          <div>
            <h3 class="font-semibold text-lg text-gray-800 mobile-text-sm">{{ user.username }}</h3>
            <p class="text-xs text-green-600 font-medium">Online</p>
          </div>
        </div>
        <button 
          @click="$emit('logout')" 
          class="btn-danger text-sm mobile-text-sm"
        >
          Logout
        </button>
      </div>
      
      <div class="p-4 border-b border-gray-200">
        <div class="relative">
          <input 
            v-model="searchQuery"
            @input="searchUsers"
            type="text" 
            placeholder="Cerca utenti..."
            class="input-field"
          />
        </div>
      </div>
      
      <div v-if="searchQuery && searchResults.length > 0" class="border-b border-gray-200">
        <div class="px-4 py-2 bg-gray-50 text-xs font-semibold text-gray-600 uppercase tracking-wide">
          Risultati ricerca
        </div>
        <div 
          v-for="result in searchResults" 
          :key="result.id"
          @click="selectContact(result)"
          class="p-4 hover:bg-gray-50 cursor-pointer border-b border-gray-100 flex items-center transition-colors duration-200 animate-slide-in"
        >
          <div class="avatar avatar-green mr-3">
            {{ result.username[0].toUpperCase() }}
          </div>
          <div class="flex-1">
            <div class="font-semibold text-gray-800">{{ result.username }}</div>
            <div class="flex items-center space-x-2">
              <div :class="!!result.is_online ? 'status-online' : 'status-offline'"></div>
              <span class="text-xs text-gray-500">
                {{ !!result.is_online ? 'Online' : 'Offline' }}
              </span>
            </div>
          </div>
        </div>
      </div>
      
      <div class="flex-1 overflow-y-auto">
        <div v-if="conversations.length === 0" class="p-8 text-center">
          <div class="text-gray-400 mb-2">
            <svg class="w-12 h-12 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
            </svg>
          </div>
          <p class="text-gray-500 text-sm">Nessuna conversazione</p>
          <p class="text-gray-400 text-xs mt-1">Cerca utenti per iniziare a chattare</p>
        </div>
        <div 
          v-for="conv in conversations" 
          :key="conv.contact_id"
          @click="selectContact({ id: conv.contact_id, username: conv.contact_username, is_online: conv.contact_online })"
          :class="['p-4 hover:bg-gray-50 cursor-pointer border-b border-gray-100 flex items-center transition-all duration-200', 
                   selectedContact?.id == conv.contact_id ? 'bg-blue-50 border-blue-200' : '']"
        >
          <div class="avatar avatar-purple mr-3">
            {{ conv.contact_username[0].toUpperCase() }}
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex justify-between items-start mb-1">
              <div class="font-semibold text-gray-800 truncate">{{ conv.contact_username }}</div>
              <div class="text-xs text-gray-500 ml-2 flex-shrink-0">
                {{ formatTime(conv.last_message_time) }}
              </div>
            </div>
            <div class="text-sm text-gray-600 truncate mb-1">{{ conv.last_message || 'Nessun messaggio' }}</div>
            <div v-if="conv.unread_count > 0" class="flex items-center space-x-2">
              <span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                {{ conv.unread_count }} nuovi
              </span>
              <div :class="!!conv.contact_online ? 'status-online' : 'status-offline'"></div>
            </div>
            <div v-else class="flex items-center space-x-2">
              <div :class="!!conv.contact_online ? 'status-online' : 'status-offline'"></div>
              <span class="text-xs text-gray-400">
                {{ !!conv.contact_online ? 'Online' : 'Offline' }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Chat Area - Responsive -->
    <div class="flex-1 flex flex-col chat-area" :class="{ 'hidden md:flex': showSidebar }">
      <div v-if="!selectedContact" class="flex-1 flex items-center justify-center">
        <div class="text-center">
          <div class="text-gray-400 mb-4">
            <svg class="w-16 h-16 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
            </svg>
          </div>
          <h3 class="text-lg font-medium text-gray-600 mb-2">Benvenuto in ChatLinkr</h3>
          <p class="text-gray-500 text-sm">Seleziona una conversazione per iniziare a chattare</p>
        </div>
      </div>
      
      <template v-else>
        <div class="card-header flex items-center justify-between">
          <div class="flex items-center space-x-3">
            <!-- Mobile back button -->
            <button 
              @click="toggleSidebar" 
              class="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors text-gray-700"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
              </svg>
            </button>
            
            <div class="avatar avatar-orange">
              {{ selectedContact.username[0].toUpperCase() }}
            </div>
            <div>
              <div class="font-semibold text-lg text-gray-800 mobile-text-sm">{{ selectedContact.username }}</div>
              <div class="flex items-center space-x-2">
                <div :class="!!selectedContact.is_online ? 'status-online' : 'status-offline'"></div>
                <span class="text-sm" :class="!!selectedContact.is_online ? 'text-green-600' : 'text-gray-500'">
                  {{ !!selectedContact.is_online ? 'Online' : 'Offline' }}
                </span>
              </div>
            </div>
          </div>
        </div>
        
        <div ref="messagesContainer" class="flex-1 overflow-y-auto p-6 space-y-4 messages-container">
          <div v-for="msg in messages" :key="msg.id" :class="['flex animate-fade-in', msg.sender_id == user.id ? 'justify-end' : 'justify-start']">
            <div :class="['message-bubble', msg.sender_id == user.id ? 'message-sent' : 'message-received', msg.is_temp ? 'message-temp' : '']">
              <div class="text-sm">{{ msg.message }}</div>
              <div :class="['text-xs mt-1', msg.sender_id == user.id ? 'text-blue-100' : 'text-gray-500']">
                <span>{{ formatTime(msg.created_at) }}</span>
              </div>
            </div>
          </div>
          <div v-if="isTyping" class="flex justify-start animate-fade-in">
            <div class="message-bubble message-received">
              <div class="typing-indicator">
                <span class="text-sm text-gray-600 mr-2">{{ selectedContact.username }} sta scrivendo</span>
                <div class="flex space-x-1">
                  <div class="typing-dot"></div>
                  <div class="typing-dot" style="animation-delay: 0.2s"></div>
                  <div class="typing-dot" style="animation-delay: 0.4s"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="p-4 bg-white border-t border-gray-200 message-input-area">
          <form @submit.prevent="sendMessage" class="flex space-x-3">
            <input 
              v-model="newMessage"
              @input="handleTyping"
              type="text" 
              placeholder="Scrivi un messaggio..."
              class="input-field flex-1"
            />
            <button 
              type="submit"
              :disabled="!newMessage.trim()"
              class="btn-primary px-6"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"></path>
              </svg>
            </button>
          </form>
        </div>
      </template>
    </div>

    <!-- User Profile Modal -->
    <UserProfile 
      :isOpen="showUserProfile" 
      :user="user" 
      @close="closeUserProfile" 
    />
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, nextTick, watch, computed } from 'vue'
import { io } from 'socket.io-client'
import UserProfile from './UserProfile.vue'

export default {
  name: 'Chat',
  components: {
    UserProfile
  },
  props: ['user', 'token'],
  emits: ['logout'],
  setup(props) {
    const conversations = ref([])
    const selectedContact = ref(null)
    const messages = ref([])
    const newMessage = ref('')
    const searchQuery = ref('')
    const searchResults = ref([])
    const messagesContainer = ref(null)
    const isTyping = ref(false)
    let typingTimeout = null
    
    // Mobile sidebar state
    const showSidebar = ref(true)
    let handleResize = null
    
    // User profile state
    const showUserProfile = ref(false)
    
    // WebSocket connection
    const socket = ref(null)

    // Definisci user come variabile reattiva per il template
    const user = computed(() => props.user)
    
    // Toggle sidebar for mobile
    const toggleSidebar = () => {
      showSidebar.value = !showSidebar.value
    }

    const loadConversations = async () => {
      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')?.replace(/\/$/, '')
        const response = await fetch(`${apiUrl}/api/messages.php?action=conversations`, {
          headers: { 'Authorization': `Bearer ${props.token}` }
        })
        const data = await response.json()
        conversations.value = data.conversations || []
      } catch (err) {
        console.error('Error loading conversations:', err)
      }
    }

    const searchUsers = async () => {
      if (!searchQuery.value.trim()) {
        searchResults.value = []
        return
      }

      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')
        const response = await fetch(`${apiUrl}/api/users.php?search=${searchQuery.value}`, {
          headers: { 'Authorization': `Bearer ${props.token}` }
        })
        const data = await response.json()
        searchResults.value = data.users || []
      } catch (err) {
        console.error('Error searching users:', err)
      }
    }

    const selectContact = async (contact) => {
      selectedContact.value = contact
      searchQuery.value = ''
      searchResults.value = []
      
      // Hide sidebar on mobile when contact is selected
      if (window.innerWidth < 768) {
        showSidebar.value = false
      }
      
      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')
        const response = await fetch(`${apiUrl}/api/messages.php?action=history&contact_id=${contact.id}`, {
          headers: { 'Authorization': `Bearer ${props.token}` }
        })
        const data = await response.json()
        messages.value = data.messages || []
        
        await nextTick()
        scrollToBottom()
        
        // Aggiorna le conversazioni per aggiornare i contatori
        await loadConversations()
        
        // Azzera il contatore dei messaggi non letti per questo contatto
        const conversation = conversations.value.find(conv => conv.contact_id == contact.id)
        if (conversation) {
          conversation.unread_count = 0
        }
      } catch (err) {
        console.error('Error loading messages:', err)
      }
    }

    const sendMessage = async () => {
      
      if (!newMessage.value.trim() || !selectedContact.value) {
        return
      }

      const messageText = newMessage.value
      newMessage.value = ''

      // Crea un messaggio temporaneo con ID temporaneo per mostrarlo immediatamente
      const tempMessage = {
        id: 'temp_' + Date.now(),
        sender_id: props.user.id,
        receiver_id: selectedContact.value.id,
        message: messageText,
        created_at: new Date().toISOString(),
        is_read: false,
        sender_username: props.user.username,
        is_temp: true // Flag per identificare messaggi temporanei
      }
      

      // Aggiungi immediatamente il messaggio alla lista
      messages.value.push(tempMessage)
      
      // Scrolla subito in basso
      await nextTick()
      scrollToBottom()

      // Invia il messaggio al server in background
      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')
        
        const requestBody = {
          receiver_id: selectedContact.value.id,
          message: messageText
        }
        
        
        const response = await fetch(`${apiUrl}/api/messages.php`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${props.token}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(requestBody)
        })

        const data = await response.json()

        if (response.ok) {
          // Sostituisci il messaggio temporaneo con quello reale dal server
          const tempIndex = messages.value.findIndex(msg => msg.id === tempMessage.id)
          if (tempIndex !== -1) {
            const realMessage = {
              ...data.message,
              sender_username: props.user.username
            }
            messages.value[tempIndex] = realMessage
          }
          
          // Invia messaggio via WebSocket se connesso
          if (socket.value && socket.value.connected) {
            socket.value.emit('send_message', {
              receiver_id: selectedContact.value.id,
              message: messageText,
              sender_id: props.user.id
            })
          }

          // Aggiorna le conversazioni per mostrare il nuovo messaggio
          await loadConversations()
          
          // Aggiorna anche il contatore dei messaggi non letti per il destinatario
          const conversation = conversations.value.find(conv => conv.contact_id == selectedContact.value.id)
          if (conversation) {
            conversation.unread_count = 0 // Il messaggio è stato inviato, non ricevuto
          }
        } else {
          // Se l'invio fallisce, rimuovi il messaggio temporaneo e mostra errore
          const tempIndex = messages.value.findIndex(msg => msg.id === tempMessage.id)
          if (tempIndex !== -1) {
            messages.value.splice(tempIndex, 1)
          }
          console.error('Error sending message:', data.error)
          // Potresti aggiungere qui una notifica di errore all'utente
        }
      } catch (err) {
        // Se l'invio fallisce, rimuovi il messaggio temporaneo
        const tempIndex = messages.value.findIndex(msg => msg.id === tempMessage.id)
        if (tempIndex !== -1) {
          messages.value.splice(tempIndex, 1)
        }
        console.error('Error sending message:', err)
        // Potresti aggiungere qui una notifica di errore all'utente
      }
    }

    const handleTyping = () => {
      if (socket.value && socket.value.connected && selectedContact.value) {
        socket.value.emit('typing', { receiver_id: selectedContact.value.id })
        
        // Stop typing dopo 2 secondi di inattività
        clearTimeout(typingTimeout)
        typingTimeout = setTimeout(() => {
          if (socket.value && socket.value.connected) {
            socket.value.emit('stop_typing', { receiver_id: selectedContact.value.id })
          }
        }, 2000)
      }
    }

    const scrollToBottom = () => {
      if (messagesContainer.value) {
        messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
      }
    }

    const formatTime = (timestamp) => {
      if (!timestamp) return ''
      const date = new Date(timestamp)
      const now = new Date()
      
      if (date.toDateString() === now.toDateString()) {
        return date.toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' })
      }
      return date.toLocaleDateString('it-IT', { day: '2-digit', month: '2-digit' })
    }

    const updateUserStatus = async (isOnline) => {
      try {
        const response = await fetch(`${import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')}/api/update_status.php`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.token}`
          },
          body: JSON.stringify({ is_online: isOnline })
        })
        
        if (response.ok) {
        }
      } catch (error) {
        console.error('Error updating user status:', error)
      }
    }

    onMounted(async () => {
      await loadConversations()
      
      // Aggiorna lo stato dell'utente corrente a online
      await updateUserStatus(true)

      // Initialize WebSocket connection
      try {
        const websocketUrl = import.meta.env.VITE_WEBSOCKET_URL
        
        socket.value = io(websocketUrl, {
          auth: { token: props.token },
          timeout: 5000
        })

        socket.value.on('connect', () => {
        })

        socket.value.on('connect_error', (error) => {
        })

        socket.value.on('receive_message', (data) => {
          
          // Aggiungi il messaggio solo se è per la conversazione corrente
          if (selectedContact.value && 
              (data.sender_id == selectedContact.value.id || data.receiver_id == selectedContact.value.id)) {
            
            // Evita duplicati
            const messageExists = messages.value.some(msg => msg.id === data.id)
            if (!messageExists) {
              messages.value.push({
                ...data,
                sender_username: data.sender_id == props.user.id ? props.user.username : selectedContact.value.username
              })
              
              nextTick(() => {
                scrollToBottom()
              })
            }
          }
          
          // Aggiorna le conversazioni
          loadConversations()
        })

        socket.value.on('typing', (data) => {
          if (selectedContact.value && data.sender_id == selectedContact.value.id) {
            isTyping.value = true
            clearTimeout(typingTimeout)
            typingTimeout = setTimeout(() => {
              isTyping.value = false
            }, 3000)
          }
        })

        socket.value.on('stop_typing', (data) => {
          if (selectedContact.value && data.sender_id == selectedContact.value.id) {
            isTyping.value = false
            clearTimeout(typingTimeout)
          }
        })

      } catch (error) {
      }

      // Initialize sidebar state based on screen size
      handleResize = () => {
        if (window.innerWidth >= 768) {
          showSidebar.value = true
        }
      }
      
      window.addEventListener('resize', handleResize)
      handleResize() // Initial check
    })

    onUnmounted(() => {
      // Cleanup resize listener
      if (handleResize) {
        window.removeEventListener('resize', handleResize)
      }
      
      // Disconnect WebSocket
      if (socket.value) {
        socket.value.disconnect()
      }
      
      // Aggiorna lo stato dell'utente a offline quando si disconnette
      updateUserStatus(false)
    })

    watch(selectedContact, () => {
      isTyping.value = false
    })

    // User profile methods
    const openUserProfile = () => {
      showUserProfile.value = true
    }

    const closeUserProfile = () => {
      showUserProfile.value = false
    }

    return {
      conversations,
      selectedContact,
      messages,
      newMessage,
      searchQuery,
      searchResults,
      messagesContainer,
      isTyping,
      user,
      showSidebar,
      toggleSidebar,
      socket,
      searchUsers,
      selectContact,
      sendMessage,
      handleTyping,
      formatTime,
      showUserProfile,
      openUserProfile,
      closeUserProfile
    }
  }
}
</script>
