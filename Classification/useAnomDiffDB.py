#%% AnomDiffDB.py
# Import modules and functions for motion model classification:
import numpy as np
import utils
import classification_net_testing
from   classification_net_testing import classification_on_file

# Specify the file to load by its motion model and associated parameters:
Model          = "FBM"    #"CTRW"    #"BM" (Other motion models are not supported by AnomDiffDB.)
Diffusivity    =    5    #1      #10
Exponent       =    1    #1/2    #3/2
Steps          =  125    #250
Trajectories   = 1024    #2048    #1024    #64    #16    #4    #1
# Load the file specified by the parameters above:
File           = r"C://Users/ZachyHeath/ASU Dropbox/Zachary Hendrix/Diffusion/AnomDiffDB/"
if Model      == "BM":
  File         = File + Model+"s(D="+str(Diffusivity)+",N="+str(Steps)+",J="+str(Trajectories)+").mat"
else:
    File       = File + Model+"s("+str(Exponent)+",N="+str(Steps)+",J="+str(Trajectories)+").mat"

# Perform classification for the loaded file:
Classification = classification_on_file(File);    print(" ");    print(" ")
# Print the classification results:
Models         = ["FBM","BM","CTRW"]
Thetas         = Classification[0].astype(int)
Theta          = np.round( np.mean(Thetas) ).astype(int)
Index          = Theta
Thetas         = [Models[i] for i in Thetas if i < len(Models)]
Theta          = Models[Theta]
#print(Thetas)
print(Theta)
Probabilities  = Classification[1]
iProbabilities = Probabilities [:,Index]
Probability    = np.mean(iProbabilities)
print(np.round(Probability*100,1),"%")