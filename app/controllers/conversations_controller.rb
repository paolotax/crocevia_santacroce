class ConversationsController < ApplicationController
  
  before_filter :authenticate_user!
  helper_method :mailbox, :conversation

  def create
    recipient_names = conversation_params(:recipients).split(', ')
    recipients = User.where(name: recipient_names).all
    # raise conversation_params(:body, :subject, :attachment).inspect
    conversation = current_user.
      send_message(recipients, *conversation_params(:body, :subject), true, *conversation_params(:attachment)).conversation

    redirect_to conversation
  end

  def reply
    
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject), true, true, *message_params(:attachment))
    
    conversation.mark_as_read(current_user)
    
    redirect_to conversation
  end

  def mark_as_read
    conversation.mark_as_read(current_user)
    redirect_to :conversations
  end

  def mark_as_unread
    conversation.mark_as_unread(current_user)
    redirect_to :conversations
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :conversations
  end
  
  def show
    conversation.mark_as_read(current_user)
  end

  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.includes(:receipts => [:message, :receiver]).find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end
end
