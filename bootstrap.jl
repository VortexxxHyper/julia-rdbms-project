(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using SearchLightDemo
const UserApp = SearchLightDemo
SearchLightDemo.main()
