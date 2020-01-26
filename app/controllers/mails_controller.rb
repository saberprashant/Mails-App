
require 'mail'

class MailsController < ApplicationController
  layout "application"

  def index

    # check if account added or not

    if $userDetails.present? && $userDetails[:username].present? && $userDetails[:password].present?
      
      begin
        allMails = Mail.find(:what => :last, :count => 100, :order => :desc)
        # allMails = Mail.all
      
        @mails = []
        $mails = []
    
        allMails.each do |current_mail|
          mail_object = Mail.read_from_string(current_mail)
          @mails.push(mail_object)
          # puts mail_object            # Outputs the To address 
        end
    
        $mails = @mails
        @accountValid = true
      rescue
        puts "Username and password not accepted"
        @accountValid = false
      end
      
    else
      redirect_to account_new_path
    end

    
    
  end

  def view
    @selMailIndex = params[:index]
    @selMailIndex = @selMailIndex.to_i
    # puts $mails.class
    # puts selMailIndex.class
    @mail = $mails[@selMailIndex]
  end

  def new
    @isNewMail = params[:new]
    index = params[:index]
    index = index.to_i

    if @isNewMail == true
      # puts "new mail"
      @mail = $mails[index]
    else
      # puts "old mail"
      @mail = $mails[index]
    end

  end

  def create

    # puts "create mail"
    from = $userDetails[:username],
    to = params[:newMail][:to]
    subject = params[:newMail][:subject]
    email_body = params[:newMail][:body]
    mail = Mail.new do
      from from
      to to
      subject subject
      body email_body
    end
    mail.deliver!
    redirect_to mails_path, alert: 'Mail sent successfully'

    # render json: {message: "An email has been sent", success: true}, status: 201   

  end

  def assign
    # assign emails to employees (add message ids to model)

    @selMailIndex = params[:index]
    @selMailIndex = @selMailIndex.to_i

    # puts @selMailIndex
    @users = User.where(userRole: 'Employee')
    # puts @users

  end

  def assign_to
    selMailIndex = params[:index].to_i
    userEmail = params[:userEmail]

    if userEmail.present?
      mail = $mails[selMailIndex]
      messageId = mail.message_id
    end

  end

  def new_account

  end

  def create_account

    if params[:newAcc].present? && params[:newAcc][:username].present?
      $userDetails = {}
      $userDetails[:username] = params[:newAcc][:username]
      $userDetails[:password] = params[:newAcc][:password]

      #Gmail retrieval method
      Mail.defaults do
        retriever_method :pop3, { :address    => "pop.gmail.com",
                                :port       => 995,
                                :user_name  => 'recent:' + $userDetails[:username],
                                :password   => $userDetails[:password],
                                :enable_ssl => true
                              }
      end    

      #GMAIL delivery method
      Mail.defaults do
        delivery_method :smtp, { :address    => "smtp.gmail.com",
                                :port       => 587,
                                :user_name  => $userDetails[:username],
                                :password   => $userDetails[:password],
                                :authentication => :plain,
                                :enable_starttls_auto => true
                              }
      end

      # puts $userDetails
      redirect_to mails_path
    else
      flash[:notice] = 'Add full details!'
    end
  end

end
