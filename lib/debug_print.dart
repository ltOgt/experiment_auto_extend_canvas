const int DEBUG_LEVEL = 3;

void dp1(String msg, {dynamic? src}) => _dpN(msg, 1, src: src);
void dp2(String msg, {dynamic? src}) => _dpN(msg, 2, src: src);
void dp3(String msg, {dynamic? src}) => _dpN(msg, 3, src: src);

void _dpN(String msg, int lvl, {dynamic? src}) {
  if (DEBUG_LEVEL >= lvl)
    print(
      "DEBUG: ${src == null ? "" : "[" + src.toString() + "]"}" + msg,
    );
}
