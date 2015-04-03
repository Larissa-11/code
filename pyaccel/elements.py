
import ctypes as _ctypes
import numpy as _numpy
import trackcpp as _trackcpp


_NUM_COORDS = 6
_DIMS = (_NUM_COORDS, _NUM_COORDS)
_coord_vector = _ctypes.c_double*_NUM_COORDS
_coord_matrix = _ctypes.c_double*_DIMS[0]*_DIMS[1]

pass_methods = _trackcpp.pm_dict


def marker(fam_name):
    """Create a marker element.

    Keyword arguments:
    fam_name -- family name
    """
    e = _trackcpp.marker_wrapper(fam_name)
    return Element(element=e)


def bpm(fam_name):
    """Create a beam position monitor element.

    Keyword arguments:
    fam_name -- family name
    """
    e = _trackcpp.bpm_wrapper(fam_name)
    return Element(element=e)


def drift(fam_name, length):
    """Create a drift element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    """
    e = _trackcpp.drift_wrapper(fam_name, length)
    return Element(element=e)


def hcorrector(fam_name,  length=0.0, hkick=0.0):
    """Create a horizontal corrector element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    hkick -- horizontal kick [rad]
    """
    e = _trackcpp.hcorrector_wrapper(fam_name, length, hkick)
    return Element(element=e)


def vcorrector(fam_name, length=0.0, vkick=0.0):
    """Create a vertical corrector element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    vkick -- vertical kick [rad]
    """
    e = _trackcpp.vcorrector_wrapper(fam_name, length, hkick)
    return Element(element=e)


def corrector(fam_name,  length=0.0, hkick=0.0, vkick=0.0):
    """Create a corrector element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    hkick -- horizontal kick [rad]
    vkick -- vertical kick [rad]
    """
    e = _trackcpp.corrector_wrapper(fam_name, length, hkick, vkick)
    return Element(element=e)


def rbend(fam_name, length, angle, angle_in=0.0, angle_out=0.0,
        gap=0.0, fint_in=0.0, fint_out=0.0, polynom_a=None,
        polynom_b=None, K=None, S=None):
    """Create a rectangular dipole element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    angle -- [rad]
    angle_in -- [rad]
    angle_out -- [rad]
    K -- [m^-2]
    S -- [m^-3]
    """
    polynom_a, polynom_b = _process_polynoms(polynom_a, polynom_b)
    if K is None: K = polynom_b[1]
    if S is None: S = polynom_b[2]
    e = _trackcpp.rbend_wrapper(fam_name, length, angle, angle_in,
            angle_out, gap, fint_in, fint_out, polynom_a, polynom_b,
            K, S)
    return Element(element=e)


def quadrupole(fam_name, length, K, nr_steps=10):
    """Create a quadrupole element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    K -- [m^-2]
    nr_steps -- number of steps (default 10)
    """
    e = _trackcpp.quadrupole_wrapper(fam_name, length, K, nr_steps)
    return Element(element=e)


def sextupole(fam_name, length, S, nr_steps=5):
    """Create a sextupole element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    S -- (1/2!)(d^2By/dx^2)/(Brho)[m^-3]
    nr_steps -- number of steps (default 5)
    """
    e = _trackcpp.sextupole_wrapper(fam_name, length, S, nr_steps)
    return Element(element=e)


def rfcavity(fam_name, length, voltage, frequency):
    """Create a RF cavity element.

    Keyword arguments:
    fam_name -- family name
    length -- [m]
    voltage -- [V]
    frequency -- [Hz]
    """
    e = _trackcpp.rfcavity_wrapper(fam_name, length, frequency, voltage)
    return Element(element=e)


def _process_polynoms(pa, pb):
    # Make sure pa and pb have same size and are initialized
    if pa is None:
        pa = [0.0,0.0,0.0]
    if pb is None:
        pb = [0.0,0.0,0.0]
    n = max([3, len(pa), len(pb)])
    for i in range(len(pa), n):
        pa.append(0.0)
    for i in range(len(pb), n):
        pb.append(0.0)
    return pa, pb


class PolynomA(object):

    def __get__(self, obj, objtype):
        return _numpy.array(obj._e.polynom_a)

    def __set__(self, obj, value):
        obj._e.polynom_a[:] = value[:]


class PolynomB(object):

    def __get__(self, obj, objtype):
        return _numpy.array(obj._e.polynom_b)

    def __set__(self, obj, value):
        obj._e.polynom_b[:] = value[:]


class Kicktable(object):

    def __init__(self, filename="", kicktable=None):
        if kicktable is not None:
            self._kicktable = kicktable
        else:
            self._kicktable = _trackcpp.Kicktable(filename)

    @property
    def filename(self):
        return self._kicktable.filename

    @property
    def length(self):
        return self._kicktable.length

    @property
    def x_min(self):
        return self._kicktable.x_min

    @property
    def x_max(self):
        return self._kicktable.x_max

    @property
    def y_min(self):
        return self._kicktable.y_min

    @property
    def y_max(self):
        return self._kicktable.y_max

    @property
    def num_pts_x(self):
        return self._kicktable.x_nrpts

    @property
    def num_pts_y(self):
        return self._kicktable.y_nrptspyaccel.accelerator.Accelerator()


class Element(object):

    t_valid_types = (list, _numpy.ndarray)
    r_valid_types = (_numpy.ndarray)

    polynom_a = PolynomA()
    polynom_b = PolynomB()

    def __init__(self, fam_name="", length=0.0, element=None):
        if element is not None:
            self._e = element
        else:
            self._e = _trackcpp.Element(fam_name, length)

    @property
    def fam_name(self):
        return self._e.fam_name

    @fam_name.setter
    def fam_name(self, value):
        self._e.fam_name = value

    @property
    def pass_method(self):
        return pass_methods[self._e.pass_method]

    @pass_method.setter
    def pass_method(self, value):
        if isinstance(value, str):
            if value not in pass_methods:
                raise ValueError("pass method '" + value + "' not found")
            else:
                self._e.pass_method = pass_methods.index(value)
        elif isinstance(value, int):
            if not (0 <= value < len(pass_methods)):
                raise IndexError("pass method index out of range")
            else:
                self._e.pass_method = value
        else:
            raise TypeError("pass method value must be string or index")

    @property
    def length(self):
        return self._e.length

    @length.setter
    @property
    def nr_steps(self):
        return self._e.nr_steps

    @nr_steps.setter
    def nr_steps(self, value):
        self._e.nr_steps = value

    @property
    def hkick(self):
        return self._e.hkick

    @hkick.setter
    def hkick(self, value):
        self._e.hkick = value

    @property
    def vkick(self):
        return self._e.vkick

    @vkick.setter
    def vkick(self, value):
        self._e.vkick = value

    @property
    def angle(self):
        return self._e.angle

    @angle.setter
    def angle(self, value):
        self._e.angle = value

    @property
    def angle_in(self):
        return self._e.angle_in

    @angle_in.setter
    def angle_in(self, value):
        self._e.angle_in = value

    @property
    def angle_out(self):
        return self._e.angle_out

    @angle_out.setter
    def angle_out(self, value):
        self._e.angle_out = value

    @property
    def gap(self):
        return self._e.gap

    @gap.setter
    def gap(self, value):
        self._e.gap = value

    @property
    def fint_in(self):
        return self._e.fint_in

    @fint_in.setter
    def fint_in(self, value):
        self._e.fint_in = value

    @property
    def fint_out(self):
        return self._e.fint_out

    @fint_out.setter
    def fint_out(self, value):
        self._e.fint_out = value

    @property
    def thin_KL(self):
        return self._e.thin_KL

    @thin_KL.setter
    def thin_KL(self, value):
        self._e._thin_KL = value

    @property
    def thin_SL(self):
        return self._e.thin_SL

    @thin_SL.setter
    def thin_SL(self, value):
        self._e._thin_SL = value

    @property
    def frequency(self):
        return self._e.frequency

    @frequency.setter
    def frequency(self, value):
        self._e.frequency = value

    @property
    def voltage(self):
        return self._e.voltage

    @voltage.setter
    def voltage(self, value):
        self._e.voltage = value

    # @property
    # def kicktable(self):
    #     return Kicktable(self._e.kicktable)
    #
    # @kicktable.setter
    # def kicktable(self, value):
    #     if not isinstance(value, Kicktable):
    #         raise TypeError('value must be of Kicktable type')
    #     self._e.kicktable = kicktable._kicktable

    @property
    def hmax(self):
        return self._e.hmax

    @hmax.setter
    def hmax(self, value):
        self._e.hmax = value

    @property
    def vmax(self):
        return self._e.vmax

    @vmax.setter
    def vmax(self, value):
        self._e.vmax = value

    @property
    def t_in(self):
        return self._get_coord_vector(self._e.t_in)

    @t_in.setter
    def t_in(self, value):
        self._check_type(value, Element.t_valid_types)
        self._check_size(value, _NUM_COORDS)
        self._set_c_array_from_vector(self._e.t_in, _NUM_COORDS, value)

    @property
    def t_out(self):
        return self._get_coord_vector(self._e.t_out)

    @t_out.setter
    def t_out(self, value):
        self._check_type(value, Element.t_valid_types)
        self._check_size(value, _NUM_COORDS)
        self._set_c_array_from_vector(self.e._t_out, _NUM_COORDS, value)

    @property
    def r_in(self):
        return self._get_coord_matrix(self._e.r_in)

    @r_in.setter
    def r_in(self, value):
        self._check_type(value, Element.r_valid_types)
        self._check_size(value, _DIMS)
        self._set_c_array_from_matrix(self._e.r_in, _DIMS, value)

    @property
    def r_out(self):
        return self._get_coord_matrix(self._e.r_out)

    @r_out.setter
    def r_out(self, value):
        self._check_type(value, Element.r_valid_types)
        self._check_size(value, _DIMS)
        self._set_c_array_from_matrix(self._e.r_out, _DIMS, value)

    def _set_c_array_from_vector(self, array, size, values):
        if not (size == len(values)):
            raise ValueError("array and vector must have same size")
        for i in range(size):
            _trackcpp.c_array_set(array, i, values[i])

    def _set_c_array_from_matrix(self, array, shape, values):
        if not (shape == values.shape):
            raise ValueError("array and matrix must have same shape")
        rows, cols = shape
        for i in range(rows):
            for j in range(cols):
                _trackcpp.c_array_set(array, i*cols + j, values[i, j])

    def _check_type(self, value, types):
        r = False
        for t in types:
            r = r or isinstance(value, t)
        if not r:
            raise TypeError("value must be list or numpy.ndarray")

    def _check_size(self, value, size):
        if not len(value) == size:
            raise ValueError("size must be " + str(size))

    def _get_coord_vector(self, pointer):
        address = int(pointer)
        c_array = _coord_vector.from_address(address)
        return _numpy.ctypeslib.as_array(c_array)

    def _get_coord_matrix(self, pointer):
        address = int(pointer)

    @gap.setter
    def gap(self, value):
        c_array = _coord_matrix.from_address(address)
        return _numpy.ctypeslib.as_array(c_array)

    def __str__(self):
        r = ''
        r += 'fam_name   : {0}'.format(self.fam_name)
        r += 'length     : {0} m'.format(self.length)
        r += 'pass_method: {0}'.format(self.pass_method)
        return r
