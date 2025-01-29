This is an implementation of standard Weighted Directional Acyclic Graph functions in GDScript. The graph is stored as a Graph Adjacency List and can perform topology sorting and calculate travel cost (shortest distance search).

Such a graph can be useful for building structures like skill trees, tech trees, or maps. You can just copy the GraphAdjacencyList script to your own project: it's intended for internal use and can be hooked to any UI.

The project contains 2 scenes:

**simple_io.tscn**: Barebones use case. The graph is hard-coded with a script, and all output goes to the console.

**skill_tree.tscn**: A showcase of using the same class with advanced UI. It contains a few @tool scripts that allow you to build a skill tree in-editor. The nodes will get visually connected as soon as you press "generate", and after launch nodes will highlight paths leading to them when clicked.

Result:
![skill_tree_example](https://github.com/user-attachments/assets/6c075399-54f5-4848-ab65-5e0d905a9b65)

In a real project you'll probably want different functionality, such as calculating costs, greying out unavailable skills, actually buying them, etc. All of that can be achieved with the same pathfinding functions.
