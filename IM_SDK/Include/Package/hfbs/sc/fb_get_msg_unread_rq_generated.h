// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGETMSGUNREADRQ_SCPACK_H_
#define FLATBUFFERS_GENERATED_FBGETMSGUNREADRQ_SCPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace scpack {

struct T_GET_MSG_UNREAD_RQ;

struct T_GET_MSG_UNREAD_RQ FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RQ_HEAD = 4,
    VT_LIST_B_ID = 6
  };
  const commonpack::S_RQ_HEAD *s_rq_head() const { return GetStruct<const commonpack::S_RQ_HEAD *>(VT_S_RQ_HEAD); }
  const flatbuffers::Vector<uint64_t> *list_b_id() const { return GetPointer<const flatbuffers::Vector<uint64_t> *>(VT_LIST_B_ID); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RQ_HEAD>(verifier, VT_S_RQ_HEAD) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_LIST_B_ID) &&
           verifier.Verify(list_b_id()) &&
           verifier.EndTable();
  }
};

struct T_GET_MSG_UNREAD_RQBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rq_head(const commonpack::S_RQ_HEAD *s_rq_head) { fbb_.AddStruct(T_GET_MSG_UNREAD_RQ::VT_S_RQ_HEAD, s_rq_head); }
  void add_list_b_id(flatbuffers::Offset<flatbuffers::Vector<uint64_t>> list_b_id) { fbb_.AddOffset(T_GET_MSG_UNREAD_RQ::VT_LIST_B_ID, list_b_id); }
  T_GET_MSG_UNREAD_RQBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GET_MSG_UNREAD_RQBuilder &operator=(const T_GET_MSG_UNREAD_RQBuilder &);
  flatbuffers::Offset<T_GET_MSG_UNREAD_RQ> Finish() {
    auto o = flatbuffers::Offset<T_GET_MSG_UNREAD_RQ>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<T_GET_MSG_UNREAD_RQ> CreateT_GET_MSG_UNREAD_RQ(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    flatbuffers::Offset<flatbuffers::Vector<uint64_t>> list_b_id = 0) {
  T_GET_MSG_UNREAD_RQBuilder builder_(_fbb);
  builder_.add_list_b_id(list_b_id);
  builder_.add_s_rq_head(s_rq_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_GET_MSG_UNREAD_RQ> CreateT_GET_MSG_UNREAD_RQDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RQ_HEAD *s_rq_head = 0,
    const std::vector<uint64_t> *list_b_id = nullptr) {
  return CreateT_GET_MSG_UNREAD_RQ(_fbb, s_rq_head, list_b_id ? _fbb.CreateVector<uint64_t>(*list_b_id) : 0);
}

inline const scpack::T_GET_MSG_UNREAD_RQ *GetT_GET_MSG_UNREAD_RQ(const void *buf) {
  return flatbuffers::GetRoot<scpack::T_GET_MSG_UNREAD_RQ>(buf);
}

inline bool VerifyT_GET_MSG_UNREAD_RQBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<scpack::T_GET_MSG_UNREAD_RQ>(nullptr);
}

inline void FinishT_GET_MSG_UNREAD_RQBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<scpack::T_GET_MSG_UNREAD_RQ> root) {
  fbb.Finish(root);
}

}  // namespace scpack

#endif  // FLATBUFFERS_GENERATED_FBGETMSGUNREADRQ_SCPACK_H_
