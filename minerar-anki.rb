require 'selenium-webdriver'
require 'pry'

class Translate
    def self.connect
        Selenium::WebDriver::Chrome::Service.driver_path="C:/Ruby27-x64/bin/chromedriver.exe"
        @driver = Selenium::WebDriver.for :chrome
        @driver.get 'https://dictionary.cambridge.org/pt/'
    end

    def self.close_terms
        btn_acccept = @driver.find_element(:id, 'onetrust-accept-btn-handler')
        btn_acccept.click
    end

    connect
    close_terms

    def self.close_login
        btn_close_modal = @driver.find_element(:css, "a[aria-label='Close login panel']")
        btn_close_modal.click
    end

    def self.get_current_language
        @driver.find_element(:class, 'lp-s_r-15').text
    end

    def self.choose_dictionary
        sleep 1
        @driver.find_element(:class, 'i-bars').click
        sleep 1
        @driver.find_element(:css, 'a[aria-label$="Inglês-Português"').click
    end

    def self.search_word word
        input_searchword = @driver.find_element(:id, 'searchword')
        input_searchword.clear
        input_searchword.send_keys word
        choose_dictionary if get_current_language == 'Inglês'
        input_searchword.submit
        close_login if @driver.find_elements(:class, "lpBanner") != []
    end

    def self.get_phrase classe
        @driver.find_elements(:class, classe).first.text
    end

    def self.print_result word
        search_word word
        word_description = get_phrase('ddef_d').capitalize
        example_phrase = get_phrase('deg').capitalize
        word_translate = get_phrase('dtrans').capitalize if @driver.find_elements(:class, 'dtrans').first != nil

        "#{word.capitalize}\n#{example_phrase}\n#{word.capitalize}: #{word_description}.\n#{word_translate}.\n\n"
    end
end

class File
    def self.read_file document
        words = []
        file = File.readlines(document, chomp: true)
        file.each do |line|
            words.push(line.strip)
        end
        words
    end

    def self.write_file file
        words = File.read_file file

        words.each do |word|
            File.open('translated_words.txt', 'a') do |line|
                line.puts(Translate.print_result word)
            end
        end
    end
end

File.write_file 'words_to_translate.txt'