// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBSERVERDISCONID_SYSPACK_H_
#define FLATBUFFERS_GENERATED_FBSERVERDISCONID_SYSPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace syspack {

struct T_SERVER_DISCON_ID;

struct T_SERVER_DISCON_ID FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_RESULT = 4
  };
  int32_t result() const { return GetField<int32_t>(VT_RESULT, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<int32_t>(verifier, VT_RESULT) &&
           verifier.EndTable();
  }
};

struct T_SERVER_DISCON_IDBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_result(int32_t result) { fbb_.AddElement<int32_t>(T_SERVER_DISCON_ID::VT_RESULT, result, 0); }
  T_SERVER_DISCON_IDBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_SERVER_DISCON_IDBuilder &operator=(const T_SERVER_DISCON_IDBuilder &);
  flatbuffers::Offset<T_SERVER_DISCON_ID> Finish() {
    auto o = flatbuffers::Offset<T_SERVER_DISCON_ID>(fbb_.EndTable(start_, 1));
    return o;
  }
};

inline flatbuffers::Offset<T_SERVER_DISCON_ID> CreateT_SERVER_DISCON_ID(flatbuffers::FlatBufferBuilder &_fbb,
    int32_t result = 0) {
  T_SERVER_DISCON_IDBuilder builder_(_fbb);
  builder_.add_result(result);
  return builder_.Finish();
}

inline const syspack::T_SERVER_DISCON_ID *GetT_SERVER_DISCON_ID(const void *buf) {
  return flatbuffers::GetRoot<syspack::T_SERVER_DISCON_ID>(buf);
}

inline bool VerifyT_SERVER_DISCON_IDBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<syspack::T_SERVER_DISCON_ID>(nullptr);
}

inline void FinishT_SERVER_DISCON_IDBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<syspack::T_SERVER_DISCON_ID> root) {
  fbb.Finish(root);
}

}  // namespace syspack

#endif  // FLATBUFFERS_GENERATED_FBSERVERDISCONID_SYSPACK_H_