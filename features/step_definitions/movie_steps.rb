# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)$/ do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
    
  if movies_table.hashes.size != Movie.all.count
    assert(false, "There is a mismatch in number of movies")
  end
end

  When /^I follow "(.*)"$/ do |link|
    if link == "Movie Title"
      click_on "Movie Title"
    else
      click_on "Release Date"
    end
  end

  Then /I should be on the home page$/ do
    visit movies_path
  end

  Then /I should see "(.*)" before "(.*)"/ do |m1, m2|
    assert page.body =~ /#{m1}.+#{m2}/m
  end


 When /I have opted to see movies rated: "(.*)"$/ do |arg1|
    Movie.all_ratings.each_entry do |rating|
      uncheck("ratings_#{rating}")
    end
    arg1.split(',').each do |check|
      check.strip!
      check("ratings_#{check}")
    end
    click_button 'Refresh'
  end

  Then /^I should see only movies rated "(.*)"$/ do |arg1|
    ratings_list = Movie.all_ratings
    ratings = page.all("table#movies tbody tr td[2]").map {|row| row.text}
    arg1.split(',').each do |rm|
      rm.strip!
      ratings_list.delete(rm)
    end
    ratings_list.each do |rating|
      if ratings.include?(rating)
        assert(false, "#{rating} should not be listed")
        break
      end
    end
  end

  Then /I should see all of the movies/ do
    rows = page.all("table#movies tbody tr td[1]").map {|row| row.text}
    assert ( rows.size == Movie.all.count )
  end