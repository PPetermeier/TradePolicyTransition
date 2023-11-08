### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ c2532ad0-7d9a-11ee-2675-dfe50f695060
begin
	import Pkg;
	Pkg.add("MetaGraphs");
	Pkg.add("Graphs")
	Pkg.add("GraphPlot");
	Pkg.add("Colors");
	Pkg.add("Random")
using DataFrames, Graphs,MetaGraphs, GraphPlot, Colors, Random
end

# ╔═╡ 2ca3100b-5470-4f02-a4d9-51781a3716ca
md"""
I try to recreate the modeling done in:
@techreport{NBERw31662,
 title = "A Theory of Trade Policy Transitions",
 author = "Bowen, Renee and Broz, J. Lawrence and Rosendorff, B. Peter",
 institution = "National Bureau of Economic Research",
 type = "Working Paper",
 series = "Working Paper Series",
 number = "31662",
 year = "2023",
 month = "September",
 doi = {10.3386/w31662},
 URL = "http://www.nber.org/papers/w31662",
 abstract = {Trade policy is set by domestic political bargaining between globalists and protectionists, representing owners of factors specific to export and import-competing sectors respectively. Consistent with the post-Civil War Era of Restriction, protectionists implement high tariffs when status quo tariffs are low. When status quo tariffs are high, reciprocal free trade combined with domestic transfers to protectionists are implemented, explaining the 1930s Era of Reciprocity with Re- distribution. Consensus emerges for Retreat from free trade when imports are high and domestic transfers are low, suggesting that US protectionist turn in the late 2010s was in part due to low levels of social transfers.},
}


First, we should try to get a good idea of the entities and functions within the model
![First Sketch of elements](TheoryofTradePolicyTransition.png)


For that we create a directional graph to simulate the tariffs each country imposes on the other. 


"""

# ╔═╡ 028a90a0-6b89-47cf-a379-ca6fe2dafcb9
begin
	function create_country()
		name = randstring(3)
		size = rand(1:2.5)
		exportsector = rand(1:30)
		startingtariff = rand(0:90)
		
		return (name, size, exportsector, startingtariff)
	end
	
	function create_dataset(Size)
		Dataset = DataFrame(Name=String[], Countrysize=Int[], ExportSector=Int[], StartingTariff=Int[])
		for i in 1:Size
			country = create_country()
			push!(Dataset, country, )
		end
		return Dataset
	end	
Dataset = create_dataset(2)
Dataset
end
	

# ╔═╡ 18f7fcac-01c9-4512-b7dc-9b78d4d3b2d6
md""""
Thinking about the modeling: 
We can use the weights of the graph model to represent the tarriff, thus each country can determine how much input from all other countries it gets (for now).
"""

# ╔═╡ 35fa3f79-26b4-4b76-bba4-c18b15c29125
begin 
	function create_graphs(Dataset)
		Datasize = nrow(Dataset)
		g = complete_digraph(Datasize)
		metagraph = MetaGraph(g)
		for destination in vertices(metagraph)
			for source in inneighbors(metagraph, destination)
				weight = Dataset.StartingTariff[destination]
				set_prop!(metagraph, source, destination,:tarriff, weight)
				end
			end
		return metagraph
	end
	metagraph = create_graphs(Dataset)
	println(props(metagraph, 1,2))
	
	
	
	
	
	
	# Plotting
	nodesize = Dataset.Countrysize
	nodefillc = range(colorant"blue", stop=colorant"green", length=length(vertices(metagraph)))
	nodelabel = Dataset.Name
	gplot(metagraph, nodesize=nodesize, nodefillc=nodefillc, nodelabel=nodelabel)
end


# ╔═╡ baa8bd2d-bbd6-4308-8e41-75449031839e


# ╔═╡ b2195223-20b5-4eaa-8a3e-418f0819f337
md"""
TODOS:

get weights to work
implement tariff rebatement
implement players with utility function
implement random election
implement negotiation:
	how do proposers decide how much to compensate? 
implement tariff change

implement a step function
cairo makie for dynamic plotting?

"""

# ╔═╡ Cell order:
# ╠═c2532ad0-7d9a-11ee-2675-dfe50f695060
# ╠═2ca3100b-5470-4f02-a4d9-51781a3716ca
# ╠═028a90a0-6b89-47cf-a379-ca6fe2dafcb9
# ╠═18f7fcac-01c9-4512-b7dc-9b78d4d3b2d6
# ╠═35fa3f79-26b4-4b76-bba4-c18b15c29125
# ╠═baa8bd2d-bbd6-4308-8e41-75449031839e
# ╠═b2195223-20b5-4eaa-8a3e-418f0819f337
