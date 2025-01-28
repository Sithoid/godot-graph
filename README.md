This is an implementation of standard Weighted Directional Acyclic Graph functions in GDScript. The graph is stored as a Graph Adjacency List and can perform topology sorting and calculate travel cost (shortest distance search).
It's intended as an internal model; you'd probably want to add both input (reading data from a @tool script) and an output (in-game graph representation).
Such a graph can be useful e.g. for building skill trees, tech trees, or maps.
Example skill tree used in the project:
![skilltree](https://github.com/user-attachments/assets/e02a0b86-507f-4993-88a8-216606b708aa)
