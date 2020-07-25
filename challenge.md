@def title = "SciML Scientific Machine Learning Challenge Problems and Datasets"
@def hascode = true
@def date = Date(2019, 3, 22)
@def rss = "Challenge problems and research datasets for the Scientific Machine Learning (SciML)"
@def tags = ["syntax", "code"]

# SciML Scientific Machine Learning Challenge Problems and Datasets

As a service to the scientific machine learning research community,
the SciML organization routinely runs and hosts challenge problems
with research datasets in order to facilitate the advancement of
scientific machine learning as a discipline. These problems come with
open datasets, description of the classical numerical techniques used
on the problem, and with starter code utilizing SciML software to
help methodological research jump directly to the cutting edge of the
field on a practical problem.

## Signal Enhancement for Magnetic Navigation Challenge Problem

Harnessing the magnetic field of the earth for navigation has shown promise as a
viable alternative to other navigation systems. A magnetic navigation system
collects its own magnetic field data using a magnetometer and uses magnetic
anomaly maps to determine the current location. The greatest challenge with
magnetic navigation arises when the magnetic field data from the magnetometer
on the navigation system encompass the magnetic field from not just the earth,
but also from the vehicle on which it is mounted. It is difficult to separate
the earth magnetic anomaly field magnitude, which is crucial for navigation,
from the total magnetic field magnitude reading from the sensor. The purpose
of this challenge problem is to decouple the earth and aircraft magnetic
signals in order to derive a clean signal from which to perform magnetic
navigation. Baseline testing on the dataset shows that the earth magnetic field
can be extracted from the total magnetic field using machine learning (ML). The
challenge is to remove the aircraft magnetic field from the total magnetic
field using a trained neural network. These challenges offer an opportunity to
construct an effective neural network for removing the aircraft magnetic field
from the dataset, using an ML algorithm integrated with physics of magnetic
navigation.

[For more information, check out the challenge problem repository](https://github.com/MIT-AI-Accelerator/MagNav.jl)

## The Helicopter SciML Challenge Problem

[The Helicopter SciML challenge problem](https://github.com/SciML/HelicopterSciML.jl)
was contributed by the University
of South-Eastern Norway. The dataset is derived from a laboratory
helicopter from which measurements of the pitch and yaw angles are
coupled with measurements of the electrical inputs into the rotaries.
Simple first principles derivations for the helicopter physics are given
and are demonstrated to not explain the full dynamics of the system.
The goal is to learn the missing physics required to give a description
of the accurately predicting system.
