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

#we're going to build out from this object now so it is easier.
giving_levels = {
	"under100" => {"donor_count" => 0, "dollar_total" => 0, "percentage_total" => 0.0},
	"100to249" => {"donor_count" => 0, "dollar_total" => 0, "percentage_total" => 0.0},
	"250to1k" => {"donor_count" => 0, "dollar_total" => 0, "percentage_total" => 0.0},
	"1kto5k" => {"donor_count" => 0, "dollar_total" => 0, "percentage_total" => 0.0},
	"above5k" => {"donor_count" => 0, "dollar_total" => 0, "percentage_total" => 0.0}
}
donor_totals = {}
grand_total = 0
csv.each do |row|
	if(Date.strptime(row['date'], '%m/%d/%y').year == 2014)
		if donor_totals.has_key? row['id']
			donor_totals[row['id']] += row['amount'].to_f
		else
			donor_totals[row['id']] = row['amount'].to_f
		end
		grand_total += row['amount'].to_f
	end
end
donor_totals.each do |id, amount|
	case amount
	when 0.0...100.0
			giving_levels["under100"]["donor_count"] += 1;
			giving_levels["under100"]["dollar_total"] += amount;
	when 100.0...250.0
			giving_levels["100to249"]["donor_count"] += 1;
			giving_levels["100to249"]["dollar_total"] += amount;
	when 250.0...1000.0
			giving_levels["250to1k"]["donor_count"] += 1;
			giving_levels["250to1k"]["dollar_total"] += amount;
	when 1000.0...5000.0
			giving_levels["1kto5k"]["donor_count"] += 1;
			giving_levels["1kto5k"]["dollar_total"] += amount;
	else
			giving_levels["above5k"]["donor_count"] += 1;
			giving_levels["above5k"]["dollar_total"] += amount;
	end
end
giving_levels.each do |level, stats|
	stats["percentage_total"] = (stats["dollar_total"]/grand_total*100).round(2)
end

puts "Total donors: #{donor_totals.size}"
giving_levels.each {|level, stats| puts "#{level} has #{stats["donor_count"]} donors in it and a total of $#{stats["dollar_total"].round(2)} in contributions, accounting for %#{stats["percentage_total"]} of the total gifts"}
finishTime=Time.now
puts "Total operation took #{finishTime - startTime} seconds"


#=============================================================