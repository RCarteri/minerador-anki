require 'selenium-webdriver'
require 'pry'

class Translate
    Selenium::WebDriver::Chrome::Service.driver_path="C:/Ruby27-x64/bin/chromedriver.exe"
    @driver = Selenium::WebDriver.for :chrome
    @driver.get 'https://dictionary.cambridge.org/pt/'

    def self.close_terms
        btn_acccept = @driver.find_elements(:id, 'onetrust-accept-btn-handler')[0]
        btn_acccept.click
    end

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

Translate.print_result 'hello'