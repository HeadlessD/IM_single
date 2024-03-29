// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBREGISTERAPNSRS_USERPACK_H_
#define FLATBUFFERS_GENERATED_FBREGISTERAPNSRS_USERPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace userpack {

struct T_REGISTER_APNS_RS;

struct T_REGISTER_APNS_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_DEVICE_TOKEN = 6
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  const flatbuffers::String *device_token() const { return GetPointer<const flatbuffers::String *>(VT_DEVICE_TOKEN); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_DEVICE_TOKEN) &&
           verifier.Verify(device_token()) &&
           verifier.EndTable();
  }
};

struct T_REGISTER_APNS_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_REGISTER_APNS_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_device_token(flatbuffers::Offset<flatbuffers::String> device_token) { fbb_.AddOffset(T_REGISTER_APNS_RS::VT_DEVICE_TOKEN, device_token); }
  T_REGISTER_APNS_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_REGISTER_APNS_RSBuilder &operator=(const T_REGISTER_APNS_RSBuilder &);
  flatbuffers::Offset<T_REGISTER_APNS_RS> Finish() {
    auto o = flatbuffers::Offset<T_REGISTER_APNS_RS>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<T_REGISTER_APNS_RS> CreateT_REGISTER_APNS_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    flatbuffers::Offset<flatbuffers::String> device_token = 0) {
  T_REGISTER_APNS_RSBuilder builder_(_fbb);
  builder_.add_device_token(device_token);
  builder_.add_s_rs_head(s_rs_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_REGISTER_APNS_RS> CreateT_REGISTER_APNS_RSDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    const char *device_token = nullptr) {
  return CreateT_REGISTER_APNS_RS(_fbb, s_rs_head, device_token ? _fbb.CreateString(device_token) : 0);
}

inline const userpack::T_REGISTER_APNS_RS *GetT_REGISTER_APNS_RS(const void *buf) {
  return flatbuffers::GetRoot<userpack::T_REGISTER_APNS_RS>(buf);
}

inline bool VerifyT_REGISTER_APNS_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<userpack::T_REGISTER_APNS_RS>(nullptr);
}

inline void FinishT_REGISTER_APNS_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<userpack::T_REGISTER_APNS_RS> root) {
  fbb.Finish(root);
}

}  // namespace userpack

#endif  // FLATBUFFERS_GENERATED_FBREGISTERAPNSRS_USERPACK_H_
