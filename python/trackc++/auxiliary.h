#ifndef _AUXILIARY_H
#define _AUXILIARY_H

#include <vector>
#include <string>
#include <ostream>
#include <iostream>
#include <cmath>

struct PassMethod {
	enum type {
		pm_identity_pass              = 0,
		pm_drift_pass                 = 1,
		pm_str_mpole_symplectic4_pass = 2,
		pm_bnd_mpole_symplectic4_pass = 3,
		pm_corrector_pass             = 4,
		pm_cavity_pass                = 5,
		pm_thinquad_pass              = 6,
		pm_thinsext_pass              = 7
	};
};

struct Status {
	enum type {
		success = 0,
		passmethod_not_defined = 1,
		passmethod_not_implemented = 2
	};
};

extern std::string passmethods[];

template <typename T> class Pos;
class Element;

#endif
