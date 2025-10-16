<template>
  <div class="flex h-screen">
    <div class="w-1/3 sidebar flex flex-col">
      <div class="card-header flex justify-between items-center">
        <div class="flex items-center space-x-3">
          <div class="avatar avatar-blue">
            {{ user.username[0].toUpperCase() }}
          </div>
          <div>
            <h3 class="font-semibold text-lg text-gray-800">{{ user.username }}</h3>
            <p class="text-xs text-green-600 font-medium">Online</p>
          </div>
        </div>
        <button 
          @click="$emit('logout')" 
          class="btn-danger text-sm"
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
            class="input-field pl-10"
          />
          <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
          </svg>
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
                   selectedContact?.id === conv.contact_id ? 'bg-blue-50 border-blue-200' : '']"
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
    
    <div class="flex-1 flex flex-col chat-area">
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
            <div class="avatar avatar-orange">
              {{ selectedContact.username[0].toUpperCase() }}
            </div>
            <div>
              <div class="font-semibold text-lg text-gray-800">{{ selectedContact.username }}</div>
              <div class="flex items-center space-x-2">
                <div :class="!!selectedContact.is_online ? 'status-online' : 'status-offline'"></div>
                <span class="text-sm" :class="!!selectedContact.is_online ? 'text-green-600' : 'text-gray-500'">
                  {{ !!selectedContact.is_online ? 'Online' : 'Offline' }}
                </span>
              </div>
            </div>
          </div>
        </div>
        
        <div ref="messagesContainer" class="flex-1 overflow-y-auto p-6 space-y-4">
          <div v-for="msg in messages" :key="msg.id" :class="['flex animate-fade-in', msg.sender_id === user.id ? 'justify-end' : 'justify-start']">
            <div :class="['message-bubble', msg.sender_id === user.id ? 'message-sent' : 'message-received', msg.is_temp ? 'message-temp' : '']">
              <div class="text-sm">{{ msg.message }}</div>
              <div :class="['text-xs mt-1 flex items-center justify-between', msg.sender_id === user.id ? 'text-blue-100' : 'text-gray-500']">
                <span>{{ formatTime(msg.created_at) }}</span>
                <div v-if="msg.sender_id === user.id" class="flex items-center ml-2">
                  <span v-if="msg.is_read" class="text-blue-200 text-xs font-bold" title="Letto">✓✓</span>
                  <span v-else class="text-blue-300 text-xs animate-pulse" title="Inviato">✓</span>
                </div>
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
        
        <div class="p-4 bg-white border-t border-gray-200">
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
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, nextTick, watch, computed } from 'vue'

export default {
  name: 'Chat',
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

    // Definisci user come variabile reattiva per il template
    const user = computed(() => props.user)

    const loadConversations = async () => {
      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'
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
        const apiUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'
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
      console.log('selectContact called with:', contact)
      selectedContact.value = contact
      searchQuery.value = ''
      searchResults.value = []
      
      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'
        const response = await fetch(`${apiUrl}/api/messages.php?action=history&contact_id=${contact.id}`, {
          headers: { 'Authorization': `Bearer ${props.token}` }
        })
        const data = await response.json()
        messages.value = data.messages || []
        console.log('Messages loaded:', messages.value)
        console.log('Current user ID:', props.user.id)
        console.log('Messages with sender_id:', messages.value.map(m => ({ id: m.id, sender_id: m.sender_id, message: m.message })))
        console.log('Current user ID type:', typeof props.user.id, 'value:', props.user.id)
        console.log('Message sender_id types:', messages.value.map(m => ({ sender_id: m.sender_id, type: typeof m.sender_id })))
        
        await nextTick()
        scrollToBottom()
        
        // Aggiorna le conversazioni per aggiornare i contatori
        await loadConversations()
        
        // Azzera il contatore dei messaggi non letti per questo contatto
        const conversation = conversations.value.find(conv => conv.contact_id === contact.id)
        if (conversation) {
          conversation.unread_count = 0
        }
      } catch (err) {
        console.error('Error loading messages:', err)
      }
    }

    const sendMessage = async () => {
      console.log('sendMessage called', { 
        message: newMessage.value, 
        selectedContact: selectedContact.value 
      })
      
      if (!newMessage.value.trim() || !selectedContact.value) {
        console.log('sendMessage blocked:', { 
          hasMessage: !!newMessage.value.trim(), 
          hasContact: !!selectedContact.value 
        })
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
      
      console.log('Creating temp message with sender_id:', props.user.id, 'for user:', props.user)

      // Aggiungi immediatamente il messaggio alla lista
      messages.value.push(tempMessage)
      console.log('Message added to list:', tempMessage)
      console.log('Total messages:', messages.value.length)
      
      // Scrolla subito in basso
      await nextTick()
      scrollToBottom()

      // Invia il messaggio al server in background
      try {
        const apiUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'
        console.log('Sending message to server:', { apiUrl, messageText, receiverId: selectedContact.value.id })
        
        const requestBody = {
          receiver_id: selectedContact.value.id,
          message: messageText
        }
        
        console.log('Request body:', requestBody)
        console.log('Authorization header:', `Bearer ${props.token}`)
        
        const response = await fetch(`${apiUrl}/api/messages.php`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${props.token}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(requestBody)
        })

        const data = await response.json()
        console.log('Server response:', data)

        if (response.ok) {
          // Sostituisci il messaggio temporaneo con quello reale dal server
          const tempIndex = messages.value.findIndex(msg => msg.id === tempMessage.id)
          if (tempIndex !== -1) {
            const realMessage = {
              ...data.message,
              sender_username: props.user.username
            }
            messages.value[tempIndex] = realMessage
            console.log('Replaced temp message with real message:', realMessage)
          }
          
          // WebSocket disabilitato - nessuna emissione

          // Aggiorna le conversazioni per mostrare il nuovo messaggio
          await loadConversations()
          
          // Aggiorna anche il contatore dei messaggi non letti per il destinatario
          const conversation = conversations.value.find(conv => conv.contact_id === selectedContact.value.id)
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
      // WebSocket disabilitato - nessun typing indicator
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
        const response = await fetch(`${import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'}/api/update_status.php`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${props.token}`
          },
          body: JSON.stringify({ is_online: isOnline })
        })
        
        if (response.ok) {
          console.log(`User status updated to ${isOnline ? 'online' : 'offline'}`)
        }
      } catch (error) {
        console.error('Error updating user status:', error)
      }
    }

    onMounted(async () => {
      await loadConversations()
      
      // Aggiorna lo stato dell'utente corrente a online
      await updateUserStatus(true)

      // WebSocket disabilitato - usiamo solo API REST
      console.log('Using REST API only - WebSocket disabled')

      // WebSocket disabilitato - nessun evento in tempo reale
    })

    onUnmounted(() => {
      // Aggiorna lo stato dell'utente a offline quando si disconnette
      updateUserStatus(false)
    })

    watch(selectedContact, () => {
      isTyping.value = false
    })

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
      searchUsers,
      selectContact,
      sendMessage,
      handleTyping,
      formatTime
    }
  }
}
</script>
