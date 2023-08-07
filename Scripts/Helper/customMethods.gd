# customMethods.gd
class_name customMethods

# Used for weighted random range
# weight is an array with every index representing the weight of its respective index
static func getWeightedRNG(weight: Array):
    var weightSum: int = 0
    for i in weight:
        weightSum += i
    
    var randomRange = randi() % (weightSum + 1)

    for i in range(weight.size()):
        randomRange -= weight[i]
        if randomRange < 0:
            return i
    
    return weight.size() - 1