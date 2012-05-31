class Downloud < Sinatra::Base
  require 'sinatra'
  require 'pony'

  DEFAULTS = {
    :email_to   => 'downloud@freenerd.de',
    :email_from => 'downloud@freenerd.de',
    :banner     => 'default'
  }

  RELEASES = YAML.load(File.read(File.join(settings.root, 'releases.yml')))
  DEFAULT_EMAIL_TO =
  Pony.options = {
    :via => :smtp,
    :via_options => {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  }

  def send_mail(release, params)
    body = """
Name: #{params[:name]}
Email: #{params[:email]}

Comment:
#{params[:description]}
    """

    puts Pony.mail(
      :to => release['email'] || DEFAULTS[:email_to],
      :from => DEFAULTS[:email_from],
      :subject => "#{params[:release]}: Feedback from #{params[:name]}",
      :body => body)
  end

  def banner_path(file_name, local=:local)
    path = ['img', 'banners', "#{file_name}.png"]
    path.unshift(settings.public_folder) if local == :local
    File.join(path)
  end

  #
  # Routes
  #
  post '/download' do
    # validate
    release = RELEASES[params[:release]]

    if release &&
      params[:name].length >= 2 &&
      params[:description].length >= 8

      send_mail(release, params)

      redirect release['download']
    else
      erb '404'.to_sym
    end
  end

  get '/:permalink' do
    @permalink = params[:permalink]

    if @release = RELEASES[@permalink]
      @banner =
        if File.exists?(banner_path(params[:permalink]))
          banner_path(params[:permalink], :public)
        else
          banner_path(DEFAULTS[:banner], :public)
        end

      erb :index
    else
      erb '404'.to_sym
    end
  end

  get '/:permalink/' do
    redirect params[:permalink]
  end
end
