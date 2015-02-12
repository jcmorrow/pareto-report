#first, some pseudo code!

#Similar to the way VBA is being used in the Excel version of this report,
#I'm going to go from CSV to CSV, and also include some terminal output 
#for debugging and such.

#In an ideal world, this would all be taking place on a server inside of a
#web framework like rails, but for an intro to ruby, this should work just fine.

#to run this program, open up a terminal, and execute using:

# ruby pareto_solution_by_josh.rb


#important caveat: This program assumes that there is a file in the same directory called data.csv
startTime = Time.now
require 'CSV'


csv_text = File.read('data.csv')
csv = CSV.parse(csv_text, :headers => true)
year2 = 2014

donors_unsorted = {}
donors_sorted = {
					"under100" => {},
					"100to249" => {},
					"250to1k" => {},
					"1kto5k" => {},
					"above5k" => {}
				}
hundreds = 0
grand_total = 0
csv.each do |row|
	if(Date.strptime(row['date'], '%m/%d/%y').year == 2014)
		if donors_unsorted.has_key? row['id']
			donors_unsorted[row['id']] += row['amount'].to_f
		else
			donors_unsorted[row['id']] = row['amount'].to_f
		end
		grand_total += row['amount'].to_f
	end
end
donors_unsorted.each do |id, amount|
	case amount
	when 0.0...100.0
			donors_sorted["under100"][id] = amount
	when 100.0...250.0
			donors_sorted["100to249"][id] = amount
	when 250.0...1000.0
			donors_sorted["250to1k"][id] = amount
	when 1000.0...5000.0
			donors_sorted["1kto5k"][id] = amount
	else
			donors_sorted["above5k"][id] = amount
	end
end
amount_summary = {}
percentage_summary = {}
donors_sorted.each do |level, donors|
	total = 0
	donors.each do |donor, amount|
		total += amount
	end
	amount_summary[level] = total
	percentage_summary[level] = total/grand_total
end

puts "Total donors: #{donors_unsorted.size}"
donors_sorted.each {|category, donors| puts "#{category} has #{donors.size} donors in it and a total of $#{amount_summary[category]} in contributions, accounting for %#{percentage_summary[category]*100} of the total gifts"}
finishTime=Time.now
puts "Total operation took #{finishTime - startTime} seconds"
puts amount_summary