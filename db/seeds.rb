DoctorSpecialty.destroy_all
Search.destroy_all
Specialty.destroy_all
Doctor.destroy_all

p "Destroying all seeds.."


require 'open-uri'


page_counter = 1
avg_waiting_time = (2..48).to_a

12.times do
  p 'page: ' + page_counter.to_s
  doctor_html = "https://en.bookimed.com/doctors/country=germany/page=#{page_counter}/"

  html = open(doctor_html).read
  doc = Nokogiri::HTML(html)
  page_counter += 1
  doc.search('.clinics-content-card-item--doctor').each do |element|
    first_name = element.search('h2').text.strip.split[0] #This is the first name
    last_name = element.search('h2').text.strip.split[1] #this is the second name
    picture_url = element.search('.clinics-content-card-img img').first.attributes.first.last.value
    address = element.search('.doctors-clinic-contact-item-title').text
    city = element.search('.name').text.strip.split(",")[1].strip # this is address
    full_address = "#{address}, #{city}"
    if Geocoder.search(full_address).empty?
      setting_address = city
    else
      setting_address = full_address
    end
    specialties = element.search('.clinics-content-card-country-name').text.strip.split(',') #these are all the spcialites
    doctor = Doctor.new(first_name: first_name, last_name: last_name, address: setting_address, picture_url: picture_url, waiting_time: avg_waiting_time.sample)
    specialties.each do |specialty|

      Specialty.create(name: specialty.strip) unless Specialty.find_by name: specialty.strip
      new_specialty = Specialty.find_by name: specialty.strip
      doctor.specialties << new_specialty
    end
    doctor.save
    p doctor.first_name
    p doctor.last_name
    p doctor.specialties
    p doctor.address
    p 'Doctor added'
    p '-----------------------------'

  end
    sleep 5
end
p "seeds done"