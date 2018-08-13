// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBECSETPROMPTSRQ_ECPACK_H_
#define FLATBUFFERS_GENERATED_FBECSETPROMPTSRQ_ECPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"
#include "fb_ec_promptmsginfo_generated.h"

namespace ecpack {

struct T_EC_SETPROMPTS_RQ;

struct T_EC_SETPROMPTS_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_PROMPTSMSGLIST = 6
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  const flatbuffers::Vector<flatbuffers::Offset<ecpack::T_PROMPTMSG_INFO>> *promptsmsglist() const { return GetPointer<const flatbuffers::Vector<flatbuffers::Offset<ecpack::T_PROMPTMSG_INFO>> *>(VT_PROMPTSMSGLIST); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_PROMPTSMSGLIST) &&
           verifier.Verify(promptsmsglist()) &&
           verifier.VerifyVectorOfTables(promptsmsglist()) &&
           verifier.EndTable();
  }
};

struct T_EC_SETPROMPTS_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_EC_SETPROMPTS_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_promptsmsglist(flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<ecpack::T_PROMPTMSG_INFO>>> promptsmsglist) { fbb_.AddOffset(T_EC_SETPROMPTS_RQ::VT_PROMPTSMSGLIST, promptsmsglist); }
  T_EC_SETPROMPTS_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_EC_SETPROMPTS_RQBuilder &operator=(const T_EC_SETPROMPTS_RQBuilder &);
  flatbuffers::Offset<T_EC_SETPROMPTS_RQ> Finish() {
    auto o = flatbuffers::Offset<T_EC_SETPROMPTS_RQ>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<T_EC_SETPROMPTS_RQ> CreateT_EC_SETPROMPTS_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<ecpack::T_PROMPTMSG_INFO>>> promptsmsglist = 0) {
  T_EC_SETPROMPTS_RQBuilder builder_(_fbb);
  builder_.add_promptsmsglist(promptsmsglist);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_EC_SETPROMPTS_RQ> CreateT_EC_SETPROMPTS_RQDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    const std::vector<flatbuffers::Offset<ecpack::T_PROMPTMSG_INFO>> *promptsmsglist = nullptr) {
  return CreateT_EC_SETPROMPTS_RQ(_fbb, s_rq_head, promptsmsglist ? _fbb.CreateVector<flatbuffers::Offset<ecpack::T_PROMPTMSG_INFO>>(*promptsmsglist) : 0);
}

inline const ecpack::T_EC_SETPROMPTS_RQ *GetT_EC_SETPROMPTS_RQ(const void *buf) {
  return flatbuffers::GetRoot<ecpack::T_EC_SETPROMPTS_RQ>(buf);
}

inline bool VerifyT_EC_SETPROMPTS_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<ecpack::T_EC_SETPROMPTS_RQ>(nullptr);
}

inline void FinishT_EC_SETPROMPTS_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<ecpack::T_EC_SETPROMPTS_RQ> root) {
  fbb.Finish(root);
}

}  // namespace ecpack

#endif  // FLATBUFFERS_GENERATED_FBECSETPROMPTSRQ_ECPACK_H_
