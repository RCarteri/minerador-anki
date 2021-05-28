require 'selenium-webdriver'
require 'pry'

class Translate
    def self.connect
        Selenium::WebDriver::Chrome::Service.driver_path="C:/Ruby27-x64/bin/chromedriver.exe"
        @driver = Selenium::WebDriver.for :chrome
        @driver.get 'https://dictionary.cambridge.org/pt/'
    end

    def self.close_terms
        btn_acccept = @driver.find_elements(:id, 'onetrust-accept-btn-handler')[0]
        btn_acccept.click
    end
    connect
    close_terms

    def self.search_word word
        input_searchword = @driver.find_elements(:id, 'searchword')[0]
        input_searchword.send_keys word
        input_searchword.submit
    end

    def self.get_phrase classe
        @driver.find_elements(:class, classe)[0].text
    end

    def self.print_result word
        search_word word
        word_description = get_phrase('ddef_d').capitalize
        example_phrase = get_phrase('deg').capitalize
        word_translate = get_phrase('dtrans').capitalize

        puts "#{word.capitalize}
        #{word.capitalize}: #{word_translate}.
        #{word_description}.
        #{example_phrase}."
    end
end

class File
    def self.read_file document
        words = []
        file = File.readlines(document, chomp: true)
        file.each do |line|
            words.push(line)
        end
        words
    end
end

words = File.read_file 'words_to_translate.txt'

# Translate.print_result 'hello'