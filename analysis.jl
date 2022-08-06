### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 77f1d8a8-14b2-11ed-2274-09a1cab3d178
using DataFrames, XLSX, StatsPlots, CSV, Statistics

# ╔═╡ c712aa38-14b3-11ed-1e56-1906d318c1aa
md"""
## Import Modules
"""

# ╔═╡ fec4c1e2-14b2-11ed-3e89-1beefc3088fe
md"""
## An Overview Of The US International Trade
"""

# ╔═╡ 986497f6-14b2-11ed-3975-71d59c8c9e80
wb = XLSX.readxlsx("data/us_trade_country.xlsx")
sheet = wb["Table 3"]
year, china = sheet["A9:A31"][:, 1], sheet["D9:D31"][:, 1]  # transform matrix to array
china = china / 1000;  # transform to billion

# ╔═╡ d5c49878-14cc-11ed-026c-7d7aeea31f83
md"""
##### US international trade balance with china on goods and service(deficit)
"""

# ╔═╡ dac53d76-14b2-11ed-12a0-1d6e2877597c
bar(year,-china, xticks=1999:2:2021, xlabel="year", ylabel="billion(us dollar)",             label="", size=(700, 400))

# ╔═╡ 57faa844-14cc-11ed-29d6-89f97310ad06
brazil = sheet["B9:B31"][:, 1] / 1000
canada = sheet["C9:C31"][:, 1] / 1000
france = sheet["E9:E31"][:, 1] / 1000
germany = sheet["F9:F31"][:, 1] /1000
hongkong = sheet["G9:G31"][:, 1] / 1000
india = sheet["H9:H31"][:, 1] / 1000
italy = sheet["I9:I31"][:, 1] / 1000
japan = sheet["J9:J31"][:, 1] / 1000
southkorean = sheet["K9:K31"][:, 1] / 1000
mexico = sheet["L9:L31"][:, 1] / 1000
saudiarabia = sheet["M9:M31"][:, 1] / 1000
singapore = sheet["N9:N31"][:, 1] / 1000
taiwan = sheet["O9:O31"][:, 1] / 1000
uk = sheet["P9:P31"][:, 1] / 1000
other = sheet["Q9:Q31"][:, 1] / 1000;

# ╔═╡ fffd9c04-14cc-11ed-1e03-85de563525ba
md"""
##### US international trade balance with some countries on goods and service(deficit)
"""

# ╔═╡ 6ae22afe-14cc-11ed-0d44-9382c60817bf
p1 = bar(year, -brazil, label="Brazil")
p2 = bar(year, -canada, label="Canada")
p3 = bar(year, -france, label="France")
p4 = bar(year, -germany, label="Germany")
p5 = bar(year, -hongkong, label="Hong Kong")
p6 = bar(year, -india, label="India")
p7 = bar(year, -italy, label="Italy")
p8 = bar(year, -japan, label="Japan")
plot(p1, p2, p3, p4, p5, p6, p7, p8, layout=(2,4), xticks=1991:10:2021, size=(700, 400))

# ╔═╡ 2fb7ad0e-14cd-11ed-2726-3fcecec19573
p1 = bar(year, -southkorean, label="South Korean")
p2 = bar(year, -mexico, label="Mexico")
p3 = bar(year, -saudiarabia, label="Saudi Arabia")
p4 = bar(year, -singapore, label="Singapore")
p5 = bar(year, -taiwan, label="Taiwan")
p6 = bar(year, -uk, label="UK")
p7 = bar(year, -other, label="other countries")
l = @layout [
    [grid(2,3)] a{0.3w}
]
plot(p1, p2, p3, p4, p5, p6, p7, layout=l, xticks=1991:10:2021, size=(700, 400))

# ╔═╡ 866180e4-14cd-11ed-0489-9d1f688dc7e7
md"""
## US Dollar Flow In China
"""

# ╔═╡ 4ed2033c-1532-11ed-233c-078dafeb04dd
md"""
##### china net puchase of US long term security
"""

# ╔═╡ d278b2fe-14cd-11ed-0a68-9fd682a021a2
wb = XLSX.readxlsx("data/us_long_term_security_china.xlsx")
sheet_pur = wb["purchase"]
df_pur = DataFrame(sheet_pur["A2:G277"], :auto)
rename!(df_pur, 1=>"year", 2=>"us_treasury_bonds_notes_p", 3=>"us_gov_agency_bonds_p", 4=>"us_corp_bonds_p", 5=>"us_corp_stocks_p",
        6=>"foreign_bonds_p", 7=>"foreign_stocks_p")  # the ! means inplace
sheet_sell = wb["sell"]
df_sell = DataFrame(sheet_sell["A2:G277"], :auto)
rename!(df_sell, 1=>"year", 2=>"us_treasury_bonds_notes_s", 3=>"us_gov_agency_bonds_s", 4=>"us_corp_bonds_s", 5=>"us_corp_stocks_s",
        6=>"foreign_bonds_s", 7=>"foreign_stocks_s")  # the ! means inplace

# merge the two bonds
df2 = innerjoin(df_pur, df_sell, on=:year)

# ╔═╡ 433f01e6-14ce-11ed-2f4a-356e95acefaf
new_frame = []
for i = 2:13
    t = 1
    new_data = zeros(23)
    for j in 1:23
        year_data = mean(df2[:, i][t:t+11])
        new_data[j] = year_data 
        t = t + 12
    end
    push!(new_frame, new_data)
end

reverse_year = reverse(year)
df3 = DataFrame(year = reverse_year, us_treasury_bonds_notes_p=new_frame[1], us_gov_agency_bonds_p=new_frame[2], us_corp_bonds_p=new_frame[3],
                 us_corp_stocks_p=new_frame[4], foreign_bonds_p=new_frame[5], foreign_stocks_p=new_frame[6],
                 us_treasury_bonds_notes_s=new_frame[7], us_gov_agency_bonds_s=new_frame[8], us_corp_bonds_s=new_frame[9],
                 us_corp_stocks_s=new_frame[10], foreign_bonds_s=new_frame[11], foreign_stocks_s=new_frame[12])

sort!(df3, :year)

df3.:us_treasury_bonds_notes_n = df3.:us_treasury_bonds_notes_p - df3.:us_treasury_bonds_notes_s
df3.:us_gov_agency_bonds_n = df3.:us_gov_agency_bonds_p - df3.:us_gov_agency_bonds_s
df3.:us_corp_bonds_n = df3.:us_corp_bonds_p - df3.:us_corp_bonds_s
df3.:us_corp_stocks_n = df3.:us_corp_stocks_p - df3.:us_corp_stocks_s

df3.:net_security_purchase = df3.:us_treasury_bonds_notes_n + df3.:us_gov_agency_bonds_n + df3.:us_corp_bonds_n + df3.:us_corp_stocks_n;

# ╔═╡ 5fc059f0-14ce-11ed-1715-593a9eb2f3dd
bar(df3.:year, df3.:net_security_purchase, xticks=1999:2:2021, xlabel="year", ylabel="billion(us dollar)", label="", size=(700, 400))

# ╔═╡ 6ce8127e-1531-11ed-0caf-2b4c52d9ae66
md"""
##### china financial account deficit
"""

# ╔═╡ 79b7c92a-1531-11ed-0837-0d13881b7f27
wb = XLSX.readxlsx("data/china_financial_account_deficit.xlsx")
sheet = wb["01"]
# transform the matrix to dataframe should assign the second argument :auto
df = DataFrame(sheet["A20:B43"], :auto)
rename!(df, 1=>"year", 2=>"deficit_amount");  # the ! means inplace

# ╔═╡ 83e8a894-1531-11ed-0578-2d9c1d06fd99
bar(df.:year[2:end], df.:deficit_amount[2:end], xticks=1999:2:2021, xlabel="year", ylabel="billion(us dollar)", label="", size=(700, 400))

# ╔═╡ d2be0ac8-1533-11ed-2dfa-dba25b9a044d
md"""
##### china foreign exchange reserve
"""

# ╔═╡ de49e4de-1533-11ed-3cce-7f59806761bc
wb_reserve = XLSX.readxlsx("data/china_foreign_exchange_reserve.xlsx")
sheet_reserve = wb_reserve["01"]
reserve_data = sheet_reserve["A2:B25"]
reserve = reserve_data[:, 2]
len = length(reserve) - 1
reserve_growth = zeros(len)
for i = 1:len
    reserve_growth[i] = reserve[i+1] - reserve[i]
end

# ╔═╡ f0d4eefa-1533-11ed-09c7-4b38b5a3dfa9
bar(reserve_data[2:end, 1], 0.6 .* reserve_growth, xticks=1999:2:2021, label="", xlabel="year",
    ylabel="billion(us dollar)", size=(700, 400))

# ╔═╡ 08ac9e6a-1534-11ed-12b2-413a5e72ce7f
difference = -china - reserve_growth
cumulative_difference = zeros(23)
cumulative_difference[1] = difference[1]
for i = 2:23
    cumulative_difference[i] = difference[i] + cumulative_difference[i-1]
end
groupedbar([reserve_growth difference], bar_position=:stack, xticks=1998:2:2021, label=["reserve growth" "trade balance difference with reserve growth"], size=(700, 400))

# ╔═╡ e36dd094-153b-11ed-293d-6b38aa1185f1
bar(year, cumulative_difference, label="cumulative difference", xticks=1999:2:2021)

# ╔═╡ 5b4d36cc-1546-11ed-0549-2be3ad6f562a


# ╔═╡ Cell order:
# ╠═c712aa38-14b3-11ed-1e56-1906d318c1aa
# ╠═77f1d8a8-14b2-11ed-2274-09a1cab3d178
# ╠═fec4c1e2-14b2-11ed-3e89-1beefc3088fe
# ╠═986497f6-14b2-11ed-3975-71d59c8c9e80
# ╠═d5c49878-14cc-11ed-026c-7d7aeea31f83
# ╠═dac53d76-14b2-11ed-12a0-1d6e2877597c
# ╠═57faa844-14cc-11ed-29d6-89f97310ad06
# ╠═fffd9c04-14cc-11ed-1e03-85de563525ba
# ╠═6ae22afe-14cc-11ed-0d44-9382c60817bf
# ╠═2fb7ad0e-14cd-11ed-2726-3fcecec19573
# ╠═866180e4-14cd-11ed-0489-9d1f688dc7e7
# ╠═4ed2033c-1532-11ed-233c-078dafeb04dd
# ╠═d278b2fe-14cd-11ed-0a68-9fd682a021a2
# ╠═433f01e6-14ce-11ed-2f4a-356e95acefaf
# ╠═5fc059f0-14ce-11ed-1715-593a9eb2f3dd
# ╠═6ce8127e-1531-11ed-0caf-2b4c52d9ae66
# ╠═79b7c92a-1531-11ed-0837-0d13881b7f27
# ╠═83e8a894-1531-11ed-0578-2d9c1d06fd99
# ╠═d2be0ac8-1533-11ed-2dfa-dba25b9a044d
# ╠═de49e4de-1533-11ed-3cce-7f59806761bc
# ╠═f0d4eefa-1533-11ed-09c7-4b38b5a3dfa9
# ╠═08ac9e6a-1534-11ed-12b2-413a5e72ce7f
# ╠═e36dd094-153b-11ed-293d-6b38aa1185f1
# ╠═5b4d36cc-1546-11ed-0549-2be3ad6f562a
